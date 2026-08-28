import test from 'node:test';
import assert from 'node:assert/strict';
import {
  handler,
  escapeHtml,
  sparkline,
  rankingTable,
  layout,
  isAccessConfigured,
  isMemberSignupEnabled,
  runDailyPipeline,
} from '../.build/worker.mjs';
import { makeEnv } from './helpers/d1.mjs';

const ctx = { waitUntil() {}, passThroughOnException() {} };

function get(path, init) {
  return new Request(`https://invest.test${path}`, init);
}

async function seedOneDay(env, date = '2026-08-27') {
  const db = env.INVEST_DB;
  await db
    .prepare(
      `INSERT INTO symbols (symbol_id, market, code, name, sector33, currency, updated_at)
       VALUES ('JP.72030','JP','72030','トヨタ自動車','輸送用機器','JPY','2026-01-01')`,
    )
    .run();
  await db
    .prepare(
      `INSERT INTO prices_daily (symbol_id, date, open, high, low, close, volume, adjustment_factor)
       VALUES ('JP.72030', ?1, 2400, 2470, 2390, 2450, 1000000, 1)`,
    )
    .bind(date)
    .run();
  await db
    .prepare(
      `INSERT INTO indicators_daily (symbol_id, date, rsi14, macd_hist, vol_ratio, sma25)
       VALUES ('JP.72030', ?1, 58.2, 1.4, 1.62, 2380)`,
    )
    .bind(date)
    .run();
  await db
    .prepare(
      `INSERT INTO scores_daily (symbol_id, date, score_version, total, c_trend, c_rsi, c_macd,
         c_ma, c_volume, c_momentum, verdict, entry_px, stop_px, target_px, rr)
       VALUES ('JP.72030', ?1, 'v1-technical', 88, 20, 10, 15, 12, 10, 8, 'BUY_NOW', 2450, 2360, 2585, 1.5)`,
    )
    .bind(date)
    .run();
  await db
    .prepare(
      `INSERT INTO signals_daily (symbol_id, date, signal_code, strength, detail)
       VALUES ('JP.72030', ?1, 'golden_cross', 7, '{"met":["sma5_above_sma25","macd_above_signal"],"crossedToday":true,"qualified":true}')`,
    )
    .bind(date)
    .run();
  await db
    .prepare(
      `INSERT INTO job_runs (job, target_date, status, started_at, finished_at)
       VALUES ('daily_pipeline', ?1, 'ok', ?2, ?2)`,
    )
    .bind(date, `${date}T10:35:00Z`)
    .run();
}

test('/api/health は認証を通さずに応答する（監視から叩くため）', async () => {
  const env = makeEnv({ CF_ACCESS_TEAM_DOMAIN: 'team.cloudflareaccess.com', CF_ACCESS_AUD: 'aud123' });
  const res = await handler.fetch(get('/api/health'), env, ctx);
  // データが無いので stale だが、401 にはならない
  assert.notEqual(res.status, 401);
  const body = await res.json();
  assert.equal(body.status, 'stale');
  assert.equal(body.lastSuccessDate, null);
});

test('/api/health は内部の数字を出さない', async () => {
  const env = makeEnv();
  await seedOneDay(env);
  const res = await handler.fetch(get('/api/health'), env, ctx);
  const body = await res.json();
  assert.deepEqual(Object.keys(body).sort(), ['lagDays', 'lastSuccessDate', 'status', 'today']);
});

test('Access が設定されていればトークン無しは 401', async () => {
  const env = makeEnv({ CF_ACCESS_TEAM_DOMAIN: 'team.cloudflareaccess.com', CF_ACCESS_AUD: 'aud123' });
  const res = await handler.fetch(get('/'), env, ctx);
  assert.equal(res.status, 401);
  const body = await res.json();
  assert.equal(body.reason, 'missing_token');
});

test('Access 未設定なら通す（ローカル開発）が、画面に警告を出す', async () => {
  const env = makeEnv();
  assert.equal(isAccessConfigured(env), false);
  const res = await handler.fetch(get('/'), env, ctx);
  assert.equal(res.status, 200);
  const html = await res.text();
  assert.match(html, /Cloudflare Access が未設定/);
});

test('ダッシュボードがランキングを描画する', async () => {
  const env = makeEnv();
  await seedOneDay(env);
  const res = await handler.fetch(get('/'), env, ctx);
  assert.equal(res.status, 200);
  assert.match(res.headers.get('content-type'), /text\/html/);
  const html = await res.text();
  assert.match(html, /トヨタ自動車/);
  assert.match(html, /88/);
  assert.match(html, /条件合致/);
  assert.match(html, /投資判断はご自身の責任/, '免責を必ず出す');
});

test('データが無いときは案内を出す（空のテーブルを見せない）', async () => {
  const env = makeEnv();
  const res = await handler.fetch(get('/'), env, ctx);
  const html = await res.text();
  assert.match(html, /データがありません/);
  assert.match(html, /db:seed:local/);
});

test('銘柄詳細がスコアの内訳と売買の目安を出す', async () => {
  const env = makeEnv();
  await seedOneDay(env);
  const res = await handler.fetch(get('/symbol/JP.72030'), env, ctx);
  assert.equal(res.status, 200);
  const html = await res.text();
  assert.match(html, /トヨタ自動車/);
  assert.match(html, /スコアの内訳/);
  assert.match(html, /損切り/);
  assert.match(html, /未評価/, 'ファンダ / ニュースは 0 点ではなく未評価と出す');
  assert.match(html, /将来の価格を予測したものではありません/);
});

test('存在しない銘柄は 404', async () => {
  const env = makeEnv();
  await seedOneDay(env);
  const res = await handler.fetch(get('/symbol/JP.99999'), env, ctx);
  assert.equal(res.status, 404);
});

test('/api/ranking が JSON を返す', async () => {
  const env = makeEnv();
  await seedOneDay(env);
  const res = await handler.fetch(get('/api/ranking?limit=5'), env, ctx);
  assert.equal(res.status, 200);
  const body = await res.json();
  assert.equal(body.date, '2026-08-27');
  assert.equal(body.ranking.length, 1);
  assert.equal(body.ranking[0].symbolId, 'JP.72030');
  assert.match(body.scoreNote, /期待リターンではない/);
});

test('/api/ranking は limit を範囲内に丸める', async () => {
  const env = makeEnv();
  await seedOneDay(env);
  for (const q of ['limit=9999', 'limit=-5', 'limit=abc']) {
    const res = await handler.fetch(get(`/api/ranking?${q}`), env, ctx);
    assert.equal(res.status, 200, q);
  }
});

test('/api/ranking は verdict で絞れる', async () => {
  const env = makeEnv();
  await seedOneDay(env);
  const hit = await (await handler.fetch(get('/api/ranking?verdict=BUY_NOW'), env, ctx)).json();
  assert.equal(hit.ranking.length, 1);
  const miss = await (await handler.fetch(get('/api/ranking?verdict=AVOID'), env, ctx)).json();
  assert.equal(miss.ranking.length, 0);
});

test('スクリーナーがフィルタ付きで描画される', async () => {
  const env = makeEnv();
  await seedOneDay(env);
  const res = await handler.fetch(get('/screener?verdict=BUY_NOW'), env, ctx);
  assert.equal(res.status, 200);
  const html = await res.text();
  assert.match(html, /スクリーナー/);
  assert.match(html, /輸送用機器/);
});

test('会員機能は規約確認が済むまで閉じている', async () => {
  const env = makeEnv();
  assert.equal(isMemberSignupEnabled(env), false);
  const res = await handler.fetch(get('/member/signup'), env, ctx);
  assert.equal(res.status, 403);
  const body = await res.json();
  assert.match(body.error, /DATA-SOURCES/);
});

test('パイプラインの手動実行は POST 限定', async () => {
  const env = makeEnv();
  const res = await handler.fetch(get('/api/run-pipeline'), env, ctx);
  assert.equal(res.status, 405);
});

test('APIキーが無ければ手動実行は 400 で理由を返す', async () => {
  const env = makeEnv({ JQUANTS_API_KEY: '' });
  const res = await handler.fetch(get('/api/run-pipeline', { method: 'POST' }), env, ctx);
  assert.equal(res.status, 400);
  const body = await res.json();
  assert.match(body.error, /JQUANTS_API_KEY/);
});

test('不正な date は 400', async () => {
  const env = makeEnv();
  const res = await handler.fetch(get('/api/run-pipeline?date=2026-8-1', { method: 'POST' }), env, ctx);
  assert.equal(res.status, 400);
});

test('未知のパスは 404', async () => {
  const env = makeEnv();
  const res = await handler.fetch(get('/nope'), env, ctx);
  assert.equal(res.status, 404);
});

test('末尾スラッシュの有無で挙動が変わらない', async () => {
  const env = makeEnv();
  await seedOneDay(env);
  const a = await handler.fetch(get('/screener'), env, ctx);
  const b = await handler.fetch(get('/screener/'), env, ctx);
  assert.equal(a.status, b.status);
});

test('内部エラーの中身をそのまま返さない', async () => {
  const env = makeEnv();
  // D1 を壊して例外を起こす
  env.INVEST_DB = {
    prepare() {
      throw new Error('SECRET_CONNECTION_STRING=abc123');
    },
  };
  const res = await handler.fetch(get('/'), env, ctx);
  assert.equal(res.status, 500);
  const text = await res.text();
  assert.ok(!text.includes('SECRET_CONNECTION_STRING'), '内部の詳細を漏らさない');
});

test('HTML エスケープ — 銘柄名にタグが混ざっても実行されない', () => {
  const rows = [
    {
      symbolId: 'JP.00010',
      code: '<img src=x onerror=alert(1)>',
      name: '<script>alert("xss")</script>',
      sector33: null,
      date: '2026-08-27',
      total: 50,
      verdict: 'WATCH',
      rsi14: 50, macdHist: 0, volRatio: 1, close: 100,
      entryPx: null, stopPx: null, targetPx: null, rr: null,
      goldenCrossStrength: null,
    },
  ];
  const html = rankingTable(rows);
  // 大事なのは「< が生で出ていないこと」。エスケープ済みのテキストに
  // onerror= という文字列が残るのは無害なので、そこを見ても意味がない。
  assert.ok(!html.includes('<script>'), 'script タグが生のまま出ていない');
  assert.ok(!html.includes('<img'), 'img タグが生のまま出ていない');
  assert.match(html, /&lt;script&gt;alert\(&quot;xss&quot;\)&lt;\/script&gt;/);
  assert.match(html, /&lt;img src=x onerror=alert\(1\)&gt;/);
});

test('HTML エスケープ — 基本', () => {
  assert.equal(escapeHtml('<a href="x">&\'</a>'), '&lt;a href=&quot;x&quot;&gt;&amp;&#39;&lt;/a&gt;');
});

test('スパークライン — 点が足りなければ描かない', () => {
  assert.equal(sparkline([]), '');
  assert.equal(sparkline([100]), '');
  assert.match(sparkline([100, 110, 105]), /<svg/);
});

test('スパークライン — すべて同値でも壊れない（ゼロ除算しない）', () => {
  const svg = sparkline([100, 100, 100]);
  assert.match(svg, /<svg/);
  assert.ok(!svg.includes('NaN'), 'NaN が座標に出ていない');
});

test('レイアウトは常に免責を含む', () => {
  const html = layout({ title: 't', siteName: 's', body: '<p>x</p>' });
  assert.match(html, /投資判断はご自身の責任/);
  assert.match(html, /noindex/, '検索エンジンに拾わせない');
  assert.match(html, /lang="ja"/);
});

test('scheduled は例外を外へ投げない（Cron を落とさない）', async () => {
  const env = makeEnv({ JQUANTS_API_KEY: '' });
  const waits = [];
  await handler.scheduled(
    { scheduledTime: Date.parse('2026-08-27T10:30:00Z'), cron: '30 10 * * 1-5' },
    env,
    { waitUntil: (p) => waits.push(p) },
  );
  await assert.doesNotReject(Promise.allSettled(waits));
});

test('サンプルデータが入っていれば画面上部に警告を出す', async () => {
  // 合成データを本物と見間違えたまま判断材料にされるのが一番まずい。
  const env = makeEnv();
  await seedOneDay(env);
  await env.INVEST_DB.prepare(
    `INSERT INTO job_runs (job, target_date, status, started_at) VALUES ('sample_seed','2026-08-27','ok','2026-08-27T00:00:00Z')`,
  ).run();

  for (const path of ['/', '/screener', '/symbol/JP.72030']) {
    const html = await (await handler.fetch(get(path), env, ctx)).text();
    assert.match(html, /サンプルデータです/, path);
  }
});

test('本物のデータだけならサンプル警告は出ない', async () => {
  const env = makeEnv();
  await seedOneDay(env);
  const html = await (await handler.fetch(get('/'), env, ctx)).text();
  assert.ok(!html.includes('サンプルデータです'));
});
