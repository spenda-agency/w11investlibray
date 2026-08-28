/**
 * サンプルデータ（`packages/worker/seed/sample.sql`）を生成する。
 *
 * 数字を手で書かず、**本番と同じ `@invest/core` に計算させる。**
 * 手書きの固定値を置くと、指標の定義を変えたときにサンプルだけ
 * 古い値のまま残り、画面で見えているものと計算が食い違う。
 *
 *   node scripts/gen-seed.mjs > packages/worker/seed/sample.sql
 */
import {
  applySplitAdjustment,
  computeSnapshots,
  computeScore,
  detectGoldenCross,
  detectExitSignals,
} from '../packages/core/.build/core.mjs';

const SYMBOLS = [
  { code: '13010', name: '極洋（サンプル）', sector: '水産・農林業', base: 4200, drift: 1.2, phase: 0 },
  { code: '67580', name: 'ソニー（サンプル）', sector: '電気機器', base: 3100, drift: 2.4, phase: 2 },
  { code: '72030', name: 'トヨタ（サンプル）', sector: '輸送用機器', base: 2400, drift: 0.8, phase: 4 },
  { code: '99840', name: 'ＳＢ（サンプル）', sector: '情報・通信業', base: 5600, drift: -0.6, phase: 1 },
  { code: '80580', name: '三菱商事（サンプル）', sector: '卸売業', base: 2900, drift: 1.6, phase: 3 },
];

const DAYS = 260;
const END = new Date('2026-08-27T00:00:00Z');

/** 決定論的な擬似乱数。生成のたびに差分が出ないようにする。 */
function lcg(seed) {
  let s = seed >>> 0;
  return () => {
    s = (Math.imul(s, 1664525) + 1013904223) >>> 0;
    return s / 0x100000000;
  };
}

function tradingDates(count, end) {
  const out = [];
  const d = new Date(end);
  while (out.length < count) {
    const day = d.getUTCDay();
    if (day !== 0 && day !== 6) out.unshift(d.toISOString().slice(0, 10));
    d.setUTCDate(d.getUTCDate() - 1);
  }
  return out;
}

function buildBars(symbol, dates) {
  const rand = lcg(symbol.base);
  let price = symbol.base;
  return dates.map((date, i) => {
    const wave = Math.sin((i + symbol.phase * 9) / 21) * symbol.base * 0.05;
    price = symbol.base + symbol.drift * i + wave + (rand() - 0.5) * symbol.base * 0.012;
    const close = Math.max(1, Math.round(price * 10) / 10);
    const spread = close * 0.012;
    return {
      symbolId: `JP.${symbol.code}`,
      date,
      open: round1(close - spread * (rand() - 0.5)),
      high: round1(close + spread * rand()),
      low: round1(close - spread * rand()),
      close,
      volume: Math.round(800_000 + Math.sin(i / 6) * 250_000 + rand() * 200_000),
      adjustmentFactor: 1,
    };
  });
}

const round1 = (v) => Math.round(v * 10) / 10;
const q = (v) => (v === null || v === undefined ? 'NULL' : typeof v === 'number' ? String(v) : `'${String(v).replace(/'/g, "''")}'`);

const dates = tradingDates(DAYS, END);
const lastDate = dates[dates.length - 1];
const lines = [];

lines.push('-- 自動生成。手で編集しないこと。');
lines.push('-- 生成: node scripts/gen-seed.mjs > packages/worker/seed/sample.sql');
lines.push('--');
lines.push('-- **これは合成データで、本物の市場データではない。** 画面の見た目と');
lines.push('-- パイプラインの出力形を確認するためのもの。銘柄名に（サンプル）が付き、');
lines.push('-- 画面上部にも警告が出る。');
lines.push('');
lines.push('DELETE FROM scores_daily;');
lines.push('DELETE FROM signals_daily;');
lines.push('DELETE FROM indicators_daily;');
lines.push('DELETE FROM prices_daily;');
lines.push('DELETE FROM symbols;');
lines.push('DELETE FROM job_runs;');
lines.push('');

for (const s of SYMBOLS) {
  lines.push(
    `INSERT INTO symbols (symbol_id, market, code, name, sector33, currency, updated_at) VALUES ` +
      `(${q(`JP.${s.code}`)}, 'JP', ${q(s.code)}, ${q(s.name)}, ${q(s.sector)}, 'JPY', ${q(lastDate)});`,
  );
}
lines.push('');

for (const s of SYMBOLS) {
  const bars = buildBars(s, dates);
  const values = bars.map(
    (b) => `(${q(b.symbolId)},${q(b.date)},${b.open},${b.high},${b.low},${b.close},${b.volume},1.0)`,
  );
  // 1 文が長くなりすぎないよう 60 行ずつに割る
  for (let i = 0; i < values.length; i += 60) {
    lines.push(
      'INSERT INTO prices_daily (symbol_id, date, open, high, low, close, volume, adjustment_factor) VALUES\n  ' +
        values.slice(i, i + 60).join(',\n  ') +
        ';',
    );
  }

  // 直近 40 営業日ぶんの指標・シグナル・スコアを、本番と同じコードで計算する
  const adjusted = applySplitAdjustment(bars);
  const snapshots = computeSnapshots(adjusted);
  const from = Math.max(1, snapshots.length - 40);

  for (let i = from; i < snapshots.length; i += 1) {
    const snap = snapshots[i];
    const prev = snapshots[i - 1] ?? null;
    const date = bars[i].date;

    lines.push(
      `INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ` +
        `(${q(`JP.${s.code}`)},${q(date)},${q(r(snap.rsi14))},${q(r(snap.macd))},${q(r(snap.macdSignal))},${q(r(snap.macdHist))},` +
        `${q(r(snap.sma5))},${q(r(snap.sma25))},${q(r(snap.sma75))},${q(r(snap.sma200))},${q(r(snap.atr14))},` +
        `${q(r(snap.volSma20))},${q(r(snap.volRatio, 4))},${q(r(snap.ret20, 6))},${q(r(snap.ret60, 6))},${q(r(snap.hi52))},${q(r(snap.lo52))});`,
    );

    const gc = detectGoldenCross(snap, prev);
    lines.push(
      `INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ` +
        `(${q(`JP.${s.code}`)},${q(date)},'golden_cross',${gc.strength},${q(JSON.stringify({ met: gc.met, crossedToday: gc.crossedToday, qualified: gc.qualified }))});`,
    );
    const ex = detectExitSignals(snap, prev);
    lines.push(
      `INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ` +
        `(${q(`JP.${s.code}`)},${q(date)},'exit',${ex.met.length},${q(JSON.stringify({ met: ex.met }))});`,
    );

    const sc = computeScore(snap);
    lines.push(
      `INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ` +
        `(${q(`JP.${s.code}`)},${q(date)},${q(sc.scoreVersion)},${q(sc.total)},${q(sc.components.trend)},${q(sc.components.rsi)},` +
        `${q(sc.components.macd)},${q(sc.components.ma)},${q(sc.components.volume)},${q(sc.components.momentum)},` +
        `${q(sc.components.fundamental)},${q(sc.components.news)},${q(sc.verdict)},` +
        `${q(r(sc.levels.entry))},${q(r(sc.levels.stop))},${q(r(sc.levels.target))},${q(r(sc.levels.rr, 3))});`,
    );
  }
  lines.push('');
}

// 「サンプルデータが入っている」ことを画面が知るための印。
lines.push(
  `INSERT INTO job_runs (job, target_date, status, started_at, finished_at, rows_written) VALUES ` +
    `('sample_seed', ${q(lastDate)}, 'ok', ${q(`${lastDate}T00:00:00Z`)}, ${q(`${lastDate}T00:00:00Z`)}, ${SYMBOLS.length});`,
);
lines.push(
  `INSERT INTO job_runs (job, target_date, status, started_at, finished_at, rows_written) VALUES ` +
    `('daily_pipeline', ${q(lastDate)}, 'ok', ${q(`${lastDate}T10:30:00Z`)}, ${q(`${lastDate}T10:35:00Z`)}, ${SYMBOLS.length});`,
);

function r(v, digits = 2) {
  if (v === null || v === undefined || !Number.isFinite(v)) return null;
  const f = 10 ** digits;
  return Math.round(v * f) / f;
}

process.stdout.write(lines.join('\n') + '\n');
