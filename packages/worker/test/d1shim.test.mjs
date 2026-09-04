import test from 'node:test';
import assert from 'node:assert/strict';
import { DatabaseSync } from 'node:sqlite';
import {
  expandPlaceholders,
  makeEnv,
} from './helpers/d1.mjs';

/**
 * テスト用 D1 シムのパラメータ束縛。
 *
 * **ここが壊れると、Windows でだけ `npm test` が落ちる。** 実際に落ちた。
 *
 * `node:sqlite` に位置引数を渡したときの束縛の仕方が Node の版で違う。
 * この環境（v22.22.2）は「`?N` の最大番号」まで、別の版は「`?` の出現数」で
 * 数えるらしく、後者では `(?1, ?2, ?2)` に 2 引数を渡しただけで
 * `column index out of range`（SQLITE_RANGE）になる。
 *
 * シムは `?N` を無印 `?` に展開してから渡すことで、この版差を消している。
 */

// ---- 展開そのもの -----------------------------------------------------------

test('?N を出現順の ? に展開する', () => {
  const cases = [
    // [SQL, 渡す値, 期待する SQL, 期待する値]
    ['VALUES (?1, ?2, ?2)', ['x', 'y'], 'VALUES (?, ?, ?)', ['x', 'y', 'y']],
    ['VALUES (?2, ?1)', ['x', 'y'], 'VALUES (?, ?)', ['y', 'x']],
    ['VALUES (?1, ?2, ?3)', ['x', 'y', 'z'], 'VALUES (?, ?, ?)', ['x', 'y', 'z']],
    ['VALUES (?1)', ['x'], 'VALUES (?)', ['x']],
    // 番号を飛ばしても、書いてある順に並ぶ
    ['WHERE a = ?3 AND b = ?1', ['x', 'y', 'z'], 'WHERE a = ? AND b = ?', ['z', 'x']],
  ];
  for (const [sql, params, wantSql, wantParams] of cases) {
    const got = expandPlaceholders(sql, params);
    assert.equal(got.sql, wantSql, sql);
    assert.deepEqual(got.params, wantParams, sql);
  }
});

test('無印の ? は触らない', () => {
  // 無印だけの経路は node:sqlite のどの版でも同じ。書き換える理由が無い。
  const got = expandPlaceholders('VALUES (?, ?, ?)', ['x', 'y', 'z']);
  assert.equal(got.sql, 'VALUES (?, ?, ?)');
  assert.deepEqual(got.params, ['x', 'y', 'z']);
});

test('展開後の SQL に ?N が残らない', () => {
  // これが版差を消している当のもの。残っていたら意味が無い。
  const { sql } = expandPlaceholders(
    `INSERT INTO waitlist (email, created_at, consented_at, source, status)
     VALUES (?1, ?2, ?2, 'lp', 'pending')`,
    ['a@example.com', '2026-01-01T00:00:00.000Z'],
  );
  assert.ok(!/\?\d/.test(sql), `?N が残っている: ${sql}`);
});

// ---- 実際の node:sqlite に通す ----------------------------------------------

test('node:sqlite は ?N の最大番号を超える引数を拒む（版差の実体）', () => {
  // **この挙動そのものを固定しておく。** 次に同じ症状が出たとき、
  // 何を疑えばいいかがここから分かる。
  const db = new DatabaseSync(':memory:');
  db.exec('CREATE TABLE t (a TEXT, b TEXT, c TEXT)');

  // 引数が最大番号（2）を超えると落ちる
  assert.throws(
    () => db.prepare('INSERT INTO t (a,b,c) VALUES (?1,?2,?2)').run('x', 'y', 'z'),
    /column index out of range/,
  );

  // 展開してから渡せば通る
  const e = expandPlaceholders('INSERT INTO t (a,b,c) VALUES (?1,?2,?2)', ['x', 'y']);
  db.prepare(e.sql).run(...e.params);
  // node:sqlite の行は null プロトタイプなので、deepEqual ではなく列で見る
  const row = db.prepare('SELECT a,b,c FROM t').get();
  assert.equal(row.a, 'x');
  assert.equal(row.b, 'y');
  assert.equal(row.c, 'y', '?2 を書いた 2 箇所に同じ値が入る');
});

test('?N を再利用する INSERT がシム越しに通る', async () => {
  // Windows で落ちた addSignups とまったく同じ形。
  const env = makeEnv();
  await env.INVEST_DB.prepare(
    `INSERT INTO waitlist (email, created_at, consented_at, source, status)
     VALUES (?1, ?2, ?2, 'lp', 'pending')`,
  )
    .bind('taro@example.com', '2026-01-01T00:00:00.000Z')
    .run();

  const rows = env.INVEST_DB.query('SELECT * FROM waitlist');
  assert.equal(rows.length, 1);
  assert.equal(rows[0].email, 'taro@example.com');
  // ?2 を 2 箇所に使っているので、両方に同じ値が入る
  assert.equal(rows[0].created_at, rows[0].consented_at);
});

test('query() も ?N を受け付ける', async () => {
  const env = makeEnv();
  await env.INVEST_DB.prepare(
    `INSERT INTO waitlist (email, created_at, consented_at, status)
     VALUES (?1, ?2, ?2, 'pending')`,
  )
    .bind('a@example.com', '2026-01-01T00:00:00.000Z')
    .run();

  const rows = env.INVEST_DB.query('SELECT email FROM waitlist WHERE email = ?1', 'a@example.com');
  assert.equal(rows.length, 1);
});
