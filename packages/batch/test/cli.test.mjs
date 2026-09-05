import test from 'node:test';
import assert from 'node:assert/strict';
import { readFile, mkdtemp, writeFile } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { parseArgs, recentWeekday, resolveRule, runBacktestCommand, insertStatements, q, runCheck, reasonFrom, splitByBytes, chunkPath, DEFAULT_MAX_BYTES } from '../.build/cli.mjs';

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
// **状態コードだけ見て本文を捨てていた。** 全 403 を「契約プランの範囲外」と
// 誤診し、しかも終了コードは 0 だった。真因は経路が V1 のままだったこと
// （API Gateway は経路に一致しないと 403 を返す）。本文には
// 「endpoint does not exist」と書いてあったのに、それを表示していなかった。

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

// V2 の経路。V1 の名前（/listed/info など）ではない。
const ALL_PATHS = ['/equities/master', '/equities/bars/daily', '/markets/calendar'];

test('check — API が返した理由をそのまま出す', async () => {
  // **ここが今回いちばん効く。** 実際に返ってきたのはこの本文で、
  // これを表示していれば一度で原因に辿り着けた。
  const { out } = await captureCheck(
    Object.fromEntries(ALL_PATHS.map((p) => [p, {
      status: 403, body: { message: 'The requested endpoint does not exist.' },
    }])),
  );
  assert.match(out, /The requested endpoint does not exist\./);
});

test('check — 全部 403 なら「プランの範囲外」とは言わない', async () => {
  const { code, out } = await captureCheck(
    Object.fromEntries(ALL_PATHS.map((p) => [p, { status: 403, body: { message: 'forbidden' } }])),
  );
  assert.match(out, /契約プランの範囲外ではない/);
  assert.match(out, /経路が間違っている/, '真因（経路違い）を筆頭に挙げていない');
  assert.match(out, /endpoint does not exist/, '見分け方を書いていない');
  // 1 本ごとに「（契約プランの範囲外の可能性）」と断定していた行は、もう出さない
  assert.ok(!out.includes('（契約プランの範囲外の可能性）'), '1 本ごとに断定している');
  assert.equal(code, 1, '必要な 3 本が取れないのに成功で返している');
});

test('check — 3 本とも通れば成功で返る', async () => {
  // **レコードは `data` に入る。** 経路ごとに違うキーだったのは V1。
  const { code, out } = await captureCheck({
    '/equities/master': { status: 200, body: { data: [{ Code: '13010', CompanyName: 'テスト' }] } },
    '/equities/bars/daily': { status: 200, body: { data: [{ Code: '13010', C: 100 }] } },
    '/markets/calendar': { status: 200, body: { data: [{ Date: '2026-09-01' }] } },
  });
  assert.equal(code, 0);
  // 実際に返ってきた項目名を見せるのが、このコマンドの本来の仕事
  assert.match(out, /実際の項目名: Code, CompanyName/);
});

test('check — 財務は叩かない（V2 の経路が未確認なので推測しない）', async () => {
  // 当てずっぽうのパスを置いて 403 を眺めるのが、今回の遠回りそのものだった。
  const { out } = await captureCheck({
    '/equities/master': { status: 200, body: { data: [] } },
    '/equities/bars/daily': { status: 200, body: { data: [] } },
    '/markets/calendar': { status: 200, body: { data: [] } },
  });
  assert.ok(!out.includes('/fins/'), '未確認の経路を叩いている');
});

test('check — 必要な 3 本のどれかが落ちたら非 0 で終わる', async () => {
  const { code, out } = await captureCheck({
    '/equities/master': { status: 200, body: { data: [] } },
    '/equities/bars/daily': { status: 500, body: { message: 'boom' } },
    '/markets/calendar': { status: 200, body: { data: [] } },
  });
  assert.match(out, /\/equities\/bars\/daily が取れない/);
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

// ---- backfill の分割 ---------------------------------------------------------
//
// **1 ファイルにまとめると流し込めない。** 日足は 1 日約 4,000 行返るので、
// 2 年で約 200 万行・約 180 MB になる。`wrangler d1 execute --file` に
// 渡せる大きさではない。容量で切って連番で書く。

test('backfill — 上限を超えたら次のファイルへ移る', () => {
  const stmts = ['a'.repeat(100), 'b'.repeat(100), 'c'.repeat(100)];
  const chunks = splitByBytes(stmts, 250);
  assert.equal(chunks.length, 2, '250 バイトに 101 バイトの文は 2 つまで');
  assert.deepEqual(chunks[0], [stmts[0], stmts[1]]);
  assert.deepEqual(chunks[1], [stmts[2]]);
});

test('backfill — 順序を崩さない（外部キーが順序に依存している）', () => {
  // market_calendar → symbols → prices_daily の順で流れる必要がある。
  const stmts = ['-- header', 'INSERT INTO market_calendar …', 'INSERT INTO prices_daily …'];
  const flat = splitByBytes(stmts, 20).flat();
  assert.deepEqual(flat, stmts, '分割で並びが変わっている');
});

test('backfill — 収まるなら 1 ファイル', () => {
  const chunks = splitByBytes(['x', 'y'], DEFAULT_MAX_BYTES);
  assert.equal(chunks.length, 1);
});

test('backfill — 1 文が上限を超えても割らない（SQL が壊れる）', () => {
  const huge = 'z'.repeat(500);
  const chunks = splitByBytes([huge], 10);
  assert.equal(chunks.length, 1);
  assert.equal(chunks[0][0], huge);
});

test('backfill — 空なら 0 ファイル', () => {
  assert.deepEqual(splitByBytes([], 100), []);
});

test('backfill — ファイル名はゼロ埋めで、sort が適用順になる', () => {
  // **ここを外すと外部キーで落ちる。** backfill-10.sql が backfill-2.sql の
  // 前に並ぶと、prices_daily が market_calendar より先に流れる。
  const names = [1, 2, 10, 11].map((i) => chunkPath('out/backfill.sql', i));
  assert.deepEqual(names, [
    'out/backfill-001.sql',
    'out/backfill-002.sql',
    'out/backfill-010.sql',
    'out/backfill-011.sql',
  ]);
  assert.deepEqual([...names].sort(), names, 'sort の順が適用順と一致しない');

  // .sql が付いていない接頭辞でも同じ
  assert.equal(chunkPath('out/backfill', 3), 'out/backfill-003.sql');
});

test('backfill — マルチバイトをバイト数で数える', () => {
  // 日本語のコメント行が入る。文字数で数えると上限を超える。
  const jp = 'あ'.repeat(10); // 30 バイト
  const chunks = splitByBytes([jp, jp], 40);
  assert.equal(chunks.length, 2, 'バイト数ではなく文字数で数えている');
});
