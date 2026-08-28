import test from 'node:test';
import assert from 'node:assert/strict';
import { readFile, mkdtemp, writeFile } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { parseArgs, recentWeekday, resolveRule, runBacktestCommand, insertStatements, q } from '../.build/cli.mjs';

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
