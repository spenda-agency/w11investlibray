import test from 'node:test';
import assert from 'node:assert/strict';
import { readFile, mkdtemp, writeFile } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { parseArgs, recentWeekday, resolveRule, runBacktestCommand, insertStatements, q, runCheck, reasonFrom } from '../.build/cli.mjs';

test('引数の解析 — 値ありとフラグのみを区別する', () => {
  const a = parseArgs(['backfill', '--from', '2026-01-01', '--to', '2026-02-01', '--verbose']);
  assert.equal(a.command, 'backfill');
  assert.equal(a.flags.from, '2026-01-01');
  assert.equal(a.flags.to, '2026-02-01');
  assert.equal(a.flags.verbose, 'true');
});

test('引数の解析 — コマンドが無ければ空文字', () => {
  assert.equal(parseArgs([]).command, '');
});

test('直近の平日 — 土日を飛ばす', () => {
  // 2026-08-27 は木曜。3 営業日前は月曜 2026-08-24。
  assert.equal(recentWeekday(new Date('2026-08-27T00:00:00Z'), 3), '2026-08-24');
  // 月曜から 1 営業日前は金曜
  assert.equal(recentWeekday(new Date('2026-08-24T00:00:00Z'), 1), '2026-08-21');
});

test('ルール名の解決', () => {
  assert.equal(resolveRule('golden-cross').id, 'golden-cross-v1');
  assert.equal(resolveRule('score-75').id, 'score-threshold-75');
  assert.throws(() => resolveRule('nope'), /不明なルール/);
});

test('SQL リテラル — クォートをエスケープする', () => {
  assert.equal(q("O'Brien"), "'O''Brien'");
  assert.equal(q(null), 'NULL');
  assert.equal(q(undefined), 'NULL');
  assert.equal(q(12.5), '12.5');
  assert.equal(q(NaN), 'NULL', '数値でない値を SQL に埋め込まない');
  assert.equal(q(Infinity), 'NULL');
});

test('INSERT 文は 1 文が大きくなりすぎないよう分割される', () => {
  const rows = Array.from({ length: 450 }, (_, i) => [`JP.${i}`, '2026-01-01', i]);
  const stmts = insertStatements('prices_daily', ['symbol_id', 'date', 'close'], rows, {
    conflictTarget: 'symbol_id, date',
    rowsPerStatement: 200,
  });
  assert.equal(stmts.length, 3);
  assert.match(stmts[0], /ON CONFLICT \(symbol_id, date\) DO NOTHING/);
  // 全行が残っている
  const total = stmts.reduce((a, s) => a + (s.match(/\('JP\./g) ?? []).length, 0);
  assert.equal(total, 450);
});

test('INSERT 文 — 行が無ければ何も出さない', () => {
  assert.deepEqual(insertStatements('t', ['a'], []), []);
});

test('バックテストが通しで走り、D1 用の SQL を書き出す', async () => {
  const dir = await mkdtemp(join(tmpdir(), 'bt-'));
  const input = join(dir, 'prices.json');
  const out = join(dir, 'backtest.sql');

  // 上昇 → 下降のトレンドを持つ 400 本
  const bars = [];
  let price = 1000;
  const start = new Date('2024-01-01T00:00:00Z');
  for (let i = 0; i < 400; i += 1) {
    price += (i < 240 ? 1.5 : -1.2) + Math.sin(i / 9) * 5;
    const close = Math.max(1, Math.round(price * 10) / 10);
    const d = new Date(start.getTime() + i * 86400000);
    bars.push({
      date: d.toISOString().slice(0, 10),
      open: close * 0.999,
      high: close * 1.01,
      low: close * 0.99,
      close,
      volume: 100000 + Math.round(Math.sin(i / 4) * 20000),
      adjustmentFactor: 1,
    });
  }
  await writeFile(input, JSON.stringify({ 'JP.72030': bars, 'JP.67580': bars }), 'utf8');

  const code = await runBacktestCommand({
    input,
    out,
    ruleName: 'golden-cross',
    universe: 'TEST',
    costPerSide: 0.001,
    maxHoldBars: 60,
  });
  assert.equal(code, 0);

  const sql = await readFile(out, 'utf8');
  assert.match(sql, /INSERT INTO backtest_runs/);
  assert.match(sql, /INSERT INTO backtest_stats/);
  assert.match(sql, /golden-cross-v1/);
});

test('バックテストの出力は実スキーマに投入できる', async () => {
  const { DatabaseSync } = await import('node:sqlite');
  const dir = await mkdtemp(join(tmpdir(), 'bt2-'));
  const input = join(dir, 'p.json');
  const out = join(dir, 'b.sql');

  const bars = [];
  let price = 500;
  for (let i = 0; i < 300; i += 1) {
    price += 1 + Math.sin(i / 7) * 4;
    const close = Math.round(price * 10) / 10;
    const d = new Date(Date.UTC(2024, 0, 1) + i * 86400000);
    bars.push({
      date: d.toISOString().slice(0, 10),
      open: close, high: close * 1.02, low: close * 0.98, close,
      volume: 50000, adjustmentFactor: 1,
    });
  }
  await writeFile(input, JSON.stringify({ 'JP.72030': bars }), 'utf8');
  await runBacktestCommand({ input, out, ruleName: 'score-70', universe: 'TEST', costPerSide: 0.001, maxHoldBars: 40 });

  const db = new DatabaseSync(':memory:');
  db.exec(await readFile(new URL('../../../migrations/0001_init.sql', import.meta.url), 'utf8'));
  // symbols への外部キーがあるので先に入れておく
  db.exec(`INSERT INTO symbols (symbol_id, market, code, name, currency, updated_at)
           VALUES ('JP.72030','JP','72030','テスト','JPY','2026-01-01')`);
  db.exec(await readFile(out, 'utf8'));

  const runs = db.prepare('SELECT * FROM backtest_runs').all();
  assert.equal(runs.length, 1);
  const stats = db.prepare('SELECT * FROM backtest_stats').all();
  assert.equal(stats.length, 1);
  assert.equal(typeof stats[0].trades, 'number');
});

test('入力が少なすぎる銘柄は黙って飛ばす', async () => {
  const dir = await mkdtemp(join(tmpdir(), 'bt3-'));
  const input = join(dir, 'p.json');
  const out = join(dir, 'b.sql');
  await writeFile(input, JSON.stringify({ 'JP.00010': [{ date: '2024-01-01', open: 1, high: 1, low: 1, close: 1, volume: 1, adjustmentFactor: 1 }] }), 'utf8');
  const code = await runBacktestCommand({ input, out, ruleName: 'golden-cross', universe: 'TEST', costPerSide: 0, maxHoldBars: 60 });
  assert.equal(code, 0);
  const sql = await readFile(out, 'utf8');
  assert.ok(!sql.includes('INSERT INTO backtest_trades'), '取引が無ければ trades は書かない');
});

// ---- check の診断 -----------------------------------------------------------
//
// **状態コードだけ見て本文を捨てていた。** Light プランに上げた直後の
// 全 403 を「契約プランの範囲外」と誤診し、しかも終了コードは 0 だった。
// /listed/info は最下位のプランでも通るので、全部 403 なら
// プランの話ではありえない——そこまで言えないと診断の意味がない。

/** console.log を捕まえて、出力と戻り値の両方を見る。 */
async function captureCheck(responses) {
  const lines = [];
  const original = console.log;
  console.log = (...args) => lines.push(args.join(' '));
  try {
    const code = await runCheck('dummy-key', 'https://api.example.test/v2', '2026-09-01',
      async (path) => responses[path] ?? { status: 500, body: { message: '未定義の経路' } });
    return { code, out: lines.join('\n') };
  } finally {
    console.log = original;
  }
}

const ALL_PATHS = [
  '/listed/info', '/prices/daily_quotes', '/markets/trading_calendar',
  '/fins/statements', '/fins/announcement',
];

test('check — API が返した理由をそのまま出す', async () => {
  // **ここが今回いちばん効く。** 理由が出ていれば一度で分かった。
  const { out } = await captureCheck(
    Object.fromEntries(ALL_PATHS.map((p) => [p, {
      status: 403, body: { message: 'The incoming token is invalid.' },
    }])),
  );
  assert.match(out, /The incoming token is invalid\./);
});

test('check — 全部 403 なら「プランの範囲外」とは言わない', async () => {
  const { code, out } = await captureCheck(
    Object.fromEntries(ALL_PATHS.map((p) => [p, { status: 403, body: { message: 'forbidden' } }])),
  );
  assert.match(out, /キーが効いていない可能性が高い/);
  assert.match(out, /発行し直す/);
  // 1 本ごとに「（契約プランの範囲外の可能性）」と断定していた行は、もう出さない
  assert.ok(!out.includes('（契約プランの範囲外の可能性）'), '1 本ごとに断定している');
  assert.equal(code, 1, '必要な 3 本が取れないのに成功で返している');
});

test('check — /fins/* だけ 403 なら先へ進んでよい', async () => {
  const rows = { status: 200, body: { info: [{ Code: '13010', CompanyName: 'テスト' }] } };
  const { code, out } = await captureCheck({
    '/listed/info': rows,
    '/prices/daily_quotes': { status: 200, body: { daily_quotes: [{ Code: '13010', C: 100 }] } },
    '/markets/trading_calendar': { status: 200, body: { trading_calendar: [{ Date: '2026-09-01' }] } },
    '/fins/statements': { status: 403, body: { message: 'not in your plan' } },
    '/fins/announcement': { status: 403, body: { message: 'not in your plan' } },
  });
  assert.match(out, /先へ進んでよい/);
  assert.equal(code, 0, 'Phase 1b の 403 で止めている');
  // 200 のときの振る舞いは変えていない
  assert.match(out, /実際の項目名: Code, CompanyName/);
});

test('check — 必要な 3 本のどれかが落ちたら非 0 で終わる', async () => {
  const { code, out } = await captureCheck({
    '/listed/info': { status: 200, body: { info: [] } },
    '/prices/daily_quotes': { status: 500, body: { message: 'boom' } },
    '/markets/trading_calendar': { status: 200, body: { trading_calendar: [] } },
    '/fins/statements': { status: 200, body: { statements: [] } },
    '/fins/announcement': { status: 200, body: { announcement: [] } },
  });
  assert.match(out, /\/prices\/daily_quotes が取れない/);
  assert.equal(code, 1);
});

test('reasonFrom — よくある形から 1 行を取り出す', () => {
  assert.equal(reasonFrom({ message: 'a' }), 'a');
  assert.equal(reasonFrom({ error: 'b' }), 'b');
  assert.equal(reasonFrom('生のテキスト'), '生のテキスト');
  // 見覚えのない形でも、何か出す（黙るより良い）
  assert.match(reasonFrom({ weird: 1 }), /weird/);
  assert.equal(reasonFrom(null), '');
  // 長すぎる本文は切る
  assert.equal(reasonFrom('x'.repeat(500)).length, 200);
});
