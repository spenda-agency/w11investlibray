import test from 'node:test';
import assert from 'node:assert/strict';
import { handler, csvCell } from '../.build/worker.mjs';
import { makeEnv } from './helpers/d1.mjs';

const ctx = { waitUntil() {}, passThroughOnException() {} };
const HOSTS = { LP_HOSTNAME: 'invest.example', APP_HOSTNAME: 'app.invest.example' };
const req = (u, init) => new Request(u, init);

async function addSignups(env, emails) {
  for (const [i, email] of emails.entries()) {
    const at = `2026-08-${String(10 + i).padStart(2, '0')}T09:00:00.000Z`;
    await env.INVEST_DB.prepare(
      `INSERT INTO waitlist (email, created_at, consented_at, source, status)
       VALUES (?1, ?2, ?2, 'lp', 'pending')`,
    )
      .bind(email, at)
      .run();
  }
}

// ---- LP 側から絶対に見えないこと ------------------------------------------

test('先行登録の一覧と CSV は LP 側から到達できない', async () => {
  // メールアドレスは個人情報。公開ホストに口を開けない。
  const env = makeEnv(HOSTS);
  await addSignups(env, ['a@example.com']);
  for (const path of ['/waitlist', '/api/waitlist.csv']) {
    const res = await handler.fetch(req(`https://invest.example${path}`), env, ctx);
    assert.equal(res.status, 404, `${path} が LP 側で応答している`);
    assert.ok(!(await res.text()).includes('a@example.com'), `${path} からメールが漏れている`);
  }
});

test('Access が有効なら認証なしでは見られない', async () => {
  const env = makeEnv({
    ...HOSTS,
    CF_ACCESS_TEAM_DOMAIN: 'team.cloudflareaccess.com',
    CF_ACCESS_AUD: 'aud123',
  });
  await addSignups(env, ['b@example.com']);
  for (const path of ['/waitlist', '/api/waitlist.csv']) {
    const res = await handler.fetch(req(`https://app.invest.example${path}`), env, ctx);
    assert.equal(res.status, 401, path);
  }
});

// ---- 画面 -------------------------------------------------------------------

test('一覧が新しい順に出る', async () => {
  const env = makeEnv(HOSTS);
  await addSignups(env, ['old@example.com', 'mid@example.com', 'new@example.com']);
  const html = await (await handler.fetch(req('https://app.invest.example/waitlist'), env, ctx)).text();

  assert.match(html, /先行登録/);
  assert.match(html, /3 件/);
  const order = ['new@example.com', 'mid@example.com', 'old@example.com'].map((e) => html.indexOf(e));
  assert.ok(order.every((i) => i > 0), '3 件とも出ていない');
  assert.deepEqual(order, [...order].sort((a, b) => a - b), '新しい順になっていない');
});

test('登録が無ければ空の表ではなく案内を出す', async () => {
  const env = makeEnv(HOSTS);
  const html = await (await handler.fetch(req('https://app.invest.example/waitlist'), env, ctx)).text();
  assert.match(html, /まだ登録がありません/);
});

test('個人情報の扱いに触れる注意書きを出す', async () => {
  const env = makeEnv(HOSTS);
  await addSignups(env, ['c@example.com']);
  const html = await (await handler.fetch(req('https://app.invest.example/waitlist'), env, ctx)).text();
  assert.match(html, /個人情報/);
});

// ---- CSV --------------------------------------------------------------------

test('CSV が添付として返る', async () => {
  const env = makeEnv(HOSTS);
  await addSignups(env, ['taro@example.com']);
  const res = await handler.fetch(req('https://app.invest.example/api/waitlist.csv'), env, ctx);

  assert.equal(res.status, 200);
  assert.match(res.headers.get('content-type'), /text\/csv/);
  assert.match(res.headers.get('content-disposition'), /attachment; filename="waitlist-\d{4}-\d{2}-\d{2}\.csv"/);

  // BOM はバイト列で確かめる。Response.text() は仕様上 UTF-8 デコード時に
  // 先頭の BOM を取り除くので、文字列にした時点では観測できない。
  const bytes = new Uint8Array(await res.clone().arrayBuffer());
  assert.deepEqual([...bytes.slice(0, 3)], [0xef, 0xbb, 0xbf], 'Excel 対策の BOM が無い');

  const body = await res.text();
  assert.match(body, /email,created_at,consented_at,source,status/);
  assert.match(body, /"taro@example\.com"/);
});

test('CSV インジェクションを防ぐ', () => {
  // 表計算ソフトは = で始まるセルを数式として実行する。
  // メールアドレスは利用者が入力した値なので素通しにできない。
  assert.equal(csvCell('=1+1'), `"'=1+1"`);
  assert.equal(csvCell('+SUM(A1)'), `"'+SUM(A1)"`);
  assert.equal(csvCell('-2'), `"'-2"`);
  assert.equal(csvCell('@import'), `"'@import"`);
  assert.equal(csvCell('taro@example.com'), '"taro@example.com"', '普通の値は変えない');
});

test('CSV のクォートを二重化する', () => {
  assert.equal(csvCell('a"b'), '"a""b"');
  assert.equal(csvCell('a,b'), '"a,b"');
});

test('危険な値を含む登録が CSV で無害化される', async () => {
  const env = makeEnv(HOSTS);
  await env.INVEST_DB.prepare(
    `INSERT INTO waitlist (email, created_at, consented_at, source, status)
     VALUES ('=cmd|calc!a1@evil.example', '2026-08-27T00:00:00.000Z', '2026-08-27T00:00:00.000Z', 'lp', 'pending')`,
  ).run();
  const body = await (await handler.fetch(req('https://app.invest.example/api/waitlist.csv'), env, ctx)).text();
  assert.match(body, /"'=cmd\|calc!a1@evil\.example"/, '先頭に \' が付いていない');
});

test('CSV の limit は範囲内に丸める', async () => {
  const env = makeEnv(HOSTS);
  await addSignups(env, ['a@example.com', 'b@example.com']);
  for (const q of ['limit=1', 'limit=99999', 'limit=-5', 'limit=abc']) {
    const res = await handler.fetch(req(`https://app.invest.example/api/waitlist.csv?${q}`), env, ctx);
    assert.equal(res.status, 200, q);
  }
  const one = await (await handler.fetch(req('https://app.invest.example/api/waitlist.csv?limit=1'), env, ctx)).text();
  assert.equal(one.trim().split('\r\n').length, 2, '見出し + 1 行');
});
