import test from 'node:test';
import assert from 'node:assert/strict';
import {
  runDailyPipeline,
  JOB_NAME,
  latestScoredDate,
  selectRanking,
  selectUniverse,
  loadRecentBars,
  lastSuccessfulJob,
  countQualifiedGoldenCross,
  marketDate,
  addDays,
  isIsoDate,
} from '../.build/worker.mjs';
import { makeEnv } from './helpers/d1.mjs';

/**
 * 偽の J-Quants。ネットワークを使わずにパイプライン全体を通す。
 * 本物の SQLite に本物のスキーマを流しているので、SQL の取り違えはここで落ちる。
 */
function fakeJquantsFetch({ symbols, barsByDate, calendar }) {
  return async (rawUrl) => {
    const url = new URL(rawUrl);
    const date = url.searchParams.get('date') ?? '';
    if (url.pathname.endsWith('/listed/info')) {
      return json({ info: symbols });
    }
    if (url.pathname.endsWith('/prices/daily_quotes')) {
      return json({ daily_quotes: barsByDate[date] ?? [] });
    }
    if (url.pathname.endsWith('/markets/trading_calendar')) {
      return json({ trading_calendar: calendar });
    }
    return json({}, 404);
  };
}

function json(body, status = 200) {
  return new Response(JSON.stringify(body), { status });
}

/** 3 銘柄ぶんの、上昇トレンドを描く日足を作る。 */
function buildFixture(days = 120) {
  const symbols = [
    { Code: '13010', CompanyName: '極洋', Sector33CodeName: '水産・農林業' },
    { Code: '72030', CompanyName: 'トヨタ自動車', Sector33CodeName: '輸送用機器' },
    { Code: '67580', CompanyName: 'ソニーグループ', Sector33CodeName: '電気機器' },
  ];
  const barsByDate = {};
  const calendar = [];
  const dates = [];

  let d = new Date('2026-03-02T00:00:00Z');
  while (dates.length < days) {
    const day = d.getUTCDay();
    const iso = d.toISOString().slice(0, 10);
    if (day !== 0 && day !== 6) {
      dates.push(iso);
      calendar.push({ Date: iso, HolidayDivision: '1' });
    } else {
      calendar.push({ Date: iso, HolidayDivision: '0' });
    }
    d = new Date(d.getTime() + 86400000);
  }

  dates.forEach((date, i) => {
    barsByDate[date] = symbols.map((s, k) => {
      const base = 1000 + k * 500;
      // 緩やかな上昇 + 銘柄ごとにずらした波
      const price = base + i * (2 + k) + Math.sin((i + k * 7) / 5) * 15;
      return {
        Code: s.Code,
        Date: date,
        Open: round(price * 0.998),
        High: round(price * 1.012),
        Low: round(price * 0.988),
        Close: round(price),
        Volume: 100000 + Math.round(Math.sin(i / 3) * 20000) + k * 5000,
        AdjustmentFactor: 1,
      };
    });
  });

  return { symbols, barsByDate, calendar, dates };
}

const round = (v) => Math.round(v * 10) / 10;

/** 過去ぶんを流し込んでから、最終日をパイプラインで処理する。 */
async function seedAndRun(env, fixture, { force = false } = {}) {
  const { dates } = fixture;
  const insert = env.INVEST_DB;

  // 銘柄マスター
  for (const s of fixture.symbols) {
    await insert
      .prepare(
        `INSERT INTO symbols (symbol_id, market, code, name, sector33, currency, updated_at)
         VALUES (?1,'JP',?2,?3,?4,'JPY','2026-01-01')`,
      )
      .bind(`JP.${s.Code}`, s.Code, s.CompanyName, s.Sector33CodeName)
      .run();
  }
  // 最終日を除く過去の足
  for (const date of dates.slice(0, -1)) {
    for (const b of fixture.barsByDate[date]) {
      await insert
        .prepare(
          `INSERT INTO prices_daily (symbol_id, date, open, high, low, close, volume, adjustment_factor)
           VALUES (?1,?2,?3,?4,?5,?6,?7,1)`,
        )
        .bind(`JP.${b.Code}`, date, b.Open, b.High, b.Low, b.Close, b.Volume)
        .run();
    }
  }

  const lastDate = dates[dates.length - 1];
  globalThis.fetch = fakeJquantsFetch(fixture);
  return runDailyPipeline(env, new Date(`${lastDate}T10:30:00Z`), { force, date: lastDate });
}

test('日付 — JST の日付に変換される', () => {
  // 19:30 JST = 10:30 UTC。UTC のまま扱うと前日を処理してしまう。
  assert.equal(marketDate(new Date('2026-08-27T10:30:00Z'), 'JP'), '2026-08-27');
  // 00:30 JST = 前日 15:30 UTC
  assert.equal(marketDate(new Date('2026-08-26T15:30:00Z'), 'JP'), '2026-08-27');
});

test('日付 — addDays と ISO 検証', () => {
  assert.equal(addDays('2026-03-01', -1), '2026-02-28');
  assert.equal(addDays('2026-12-31', 1), '2027-01-01');
  assert.ok(isIsoDate('2026-08-27'));
  assert.ok(!isIsoDate('2026-13-01'));
  assert.ok(!isIsoDate('20260827'));
});

test('パイプラインが通しで動き、スコアが保存される', async () => {
  const env = makeEnv();
  const fixture = buildFixture(120);
  const result = await seedAndRun(env, fixture);

  assert.equal(result.skipped, false);
  assert.equal(result.symbols, 3);
  assert.equal(result.prices, 3);
  assert.equal(result.scored, 3, `steps: ${result.steps.join(' ')}`);

  const date = await latestScoredDate(env.INVEST_DB);
  assert.equal(date, result.date);

  const ranking = await selectRanking(env.INVEST_DB, date, { limit: 10 });
  assert.equal(ranking.length, 3);
  for (const row of ranking) {
    assert.ok(row.total === null || (row.total >= 0 && row.total <= 100), `total ${row.total}`);
    assert.ok(['BUY_NOW', 'BUY_WATCH', 'WATCH', 'AVOID'].includes(row.verdict));
    assert.ok(row.name.length > 0, '銘柄名が JOIN できている');
    assert.ok(row.close !== null, '終値が JOIN できている');
  }
  // 降順であること
  const totals = ranking.map((r) => r.total ?? -1);
  assert.deepEqual(totals, [...totals].sort((a, b) => b - a));
});

test('指標とシグナルも同じ日付で保存される', async () => {
  const env = makeEnv();
  const fixture = buildFixture(120);
  const result = await seedAndRun(env, fixture);

  const indicators = env.INVEST_DB.query(
    'SELECT * FROM indicators_daily WHERE date = ?1',
    result.date,
  );
  assert.equal(indicators.length, 3);
  assert.ok(indicators[0].rsi14 !== null, 'RSI が入っている');
  assert.ok(indicators[0].sma25 !== null, '25日線が入っている');

  const signals = env.INVEST_DB.query('SELECT * FROM signals_daily WHERE date = ?1', result.date);
  // 銘柄ごとに golden_cross と exit の 2 行
  assert.equal(signals.length, 6);
  const codes = new Set(signals.map((s) => s.signal_code));
  assert.deepEqual([...codes].sort(), ['exit', 'golden_cross']);

  const gc = signals.find((s) => s.signal_code === 'golden_cross');
  const detail = JSON.parse(gc.detail);
  assert.ok(Array.isArray(detail.met));
  assert.equal(typeof detail.qualified, 'boolean');
});

test('同じ日を 2 度走らせても二重に書かない', async () => {
  const env = makeEnv();
  const fixture = buildFixture(120);
  const first = await seedAndRun(env, fixture);
  assert.equal(first.skipped, false);

  // 2 度目は job_runs を見てスキップする
  globalThis.fetch = fakeJquantsFetch(fixture);
  const second = await runDailyPipeline(env, new Date(`${first.date}T10:30:00Z`), { date: first.date });
  assert.equal(second.skipped, true);

  const rows = env.INVEST_DB.query('SELECT COUNT(*) AS n FROM scores_daily WHERE date = ?1', first.date);
  assert.equal(rows[0].n, 3, '行が増えていない');
});

test('force を付ければ成功済みの日でも走り直す', async () => {
  const env = makeEnv();
  const fixture = buildFixture(120);
  const first = await seedAndRun(env, fixture);

  globalThis.fetch = fakeJquantsFetch(fixture);
  const again = await runDailyPipeline(env, new Date(`${first.date}T10:30:00Z`), {
    date: first.date,
    force: true,
  });
  assert.equal(again.skipped, false);
  assert.equal(again.scored, 3);

  const rows = env.INVEST_DB.query('SELECT COUNT(*) AS n FROM scores_daily WHERE date = ?1', first.date);
  assert.equal(rows[0].n, 3, 'UPSERT なので行数は変わらない');
});

test('休場日は前日のスコアを上書きしない', async () => {
  const env = makeEnv();
  const fixture = buildFixture(120);
  const lastDate = fixture.dates[fixture.dates.length - 1];
  // カレンダー上、その日を休場にする
  fixture.calendar = fixture.calendar.map((c) =>
    c.Date === lastDate ? { ...c, HolidayDivision: '0' } : c,
  );

  const result = await seedAndRun(env, fixture);
  assert.equal(result.skipped, true);
  assert.ok(result.steps.includes('market_closed'));

  const rows = env.INVEST_DB.query('SELECT COUNT(*) AS n FROM scores_daily');
  assert.equal(rows[0].n, 0, '休場日にスコアを書かない');
});

test('失敗したら job_runs に error が残り、成功扱いにならない', async () => {
  const env = makeEnv();
  const fixture = buildFixture(30);
  globalThis.fetch = async () => new Response('boom', { status: 500 });

  await assert.rejects(() =>
    runDailyPipeline(env, new Date('2026-08-27T10:30:00Z'), { date: '2026-08-27' }),
  );

  const rows = env.INVEST_DB.query('SELECT * FROM job_runs WHERE job = ?1', JOB_NAME);
  assert.equal(rows[0].status, 'error');
  assert.ok(rows[0].error.includes('500'));

  const last = await lastSuccessfulJob(env.INVEST_DB, JOB_NAME);
  assert.equal(last, null, '失敗は成功として記録されない');
});

test('データが足りない銘柄は候補に出さない', async () => {
  const env = makeEnv();
  // 30 本未満しか無い
  const fixture = buildFixture(20);
  const result = await seedAndRun(env, fixture);
  assert.equal(result.scored, 0, '指標が意味を持たない銘柄は書かない');
});

test('ユニバースは売買代金の大きい順に絞られる', async () => {
  const env = makeEnv();
  const fixture = buildFixture(60);
  await seedAndRun(env, fixture);
  const lastDate = fixture.dates[fixture.dates.length - 1];

  const universe = await selectUniverse(env.INVEST_DB, 'JP', lastDate, 2);
  assert.equal(universe.length, 2);
  // 価格が高い銘柄ほど売買代金が大きくなる作りにしてある
  assert.ok(universe.includes('JP.67580'), `universe: ${universe.join(',')}`);
});

test('過去の足は昇順で読み出される（指標が昇順を前提にしている）', async () => {
  const env = makeEnv();
  const fixture = buildFixture(60);
  await seedAndRun(env, fixture);
  const lastDate = fixture.dates[fixture.dates.length - 1];

  const bars = await loadRecentBars(env.INVEST_DB, ['JP.72030'], lastDate, 300);
  const list = bars.get('JP.72030');
  assert.ok(list.length > 30);
  for (let i = 1; i < list.length; i += 1) {
    assert.ok(list[i - 1].date < list[i].date, `${list[i - 1].date} → ${list[i].date}`);
  }
  assert.equal(list[list.length - 1].date, lastDate);
});

test('ゴールデンクロスの件数は条件を満たしたものだけ数える', async () => {
  const env = makeEnv();
  const fixture = buildFixture(120);
  const result = await seedAndRun(env, fixture);

  const strict = await countQualifiedGoldenCross(env.INVEST_DB, result.date, 6);
  const loose = await countQualifiedGoldenCross(env.INVEST_DB, result.date, 1);
  assert.ok(strict <= loose, `strict ${strict} / loose ${loose}`);
  assert.ok(loose <= 3);
});

test('スナップショットが R2 に書かれる', async () => {
  const env = makeEnv();
  const fixture = buildFixture(120);
  const result = await seedAndRun(env, fixture);

  const latest = await env.INVEST_R2.get('snapshots/latest.json');
  assert.ok(latest !== null, 'latest.json が無い');
  const parsed = JSON.parse(await latest.text());
  assert.equal(parsed.date, result.date);
  assert.equal(parsed.ranking.length, 3);

  const dated = await env.INVEST_R2.get(`snapshots/${result.date}.json`);
  assert.ok(dated !== null, '日付付きのスナップショットが無い');
});

test('上場一覧から消えた銘柄は削除ではなく delisted_at が立つ', async () => {
  const env = makeEnv();
  const fixture = buildFixture(60);
  await seedAndRun(env, fixture);

  // 翌営業日、1 銘柄が一覧から消える
  const nextDate = '2026-09-01';
  const remaining = fixture.symbols.filter((s) => s.Code !== '13010');
  globalThis.fetch = fakeJquantsFetch({
    symbols: remaining,
    barsByDate: { [nextDate]: [] },
    calendar: [{ Date: nextDate, HolidayDivision: '1' }],
  });
  await runDailyPipeline(env, new Date(`${nextDate}T10:30:00Z`), { date: nextDate });

  const rows = env.INVEST_DB.query('SELECT symbol_id, delisted_at FROM symbols ORDER BY symbol_id');
  assert.equal(rows.length, 3, '行は消さない（生存者バイアスを避けるため）');
  const delisted = rows.find((r) => r.symbol_id === 'JP.13010');
  assert.equal(delisted.delisted_at, nextDate);
  // 価格も残っている
  const prices = env.INVEST_DB.query('SELECT COUNT(*) AS n FROM prices_daily WHERE symbol_id = ?1', 'JP.13010');
  assert.ok(prices[0].n > 0, '廃止銘柄の価格も残す');
});
