import test from 'node:test';
import assert from 'node:assert/strict';
import {
  handler,
  resolveSite,
  normalisePath,
  lpBasePath,
  appUrl,
  normaliseEmail,
  lpPage,
} from '../.build/worker.mjs';
import { makeEnv } from './helpers/d1.mjs';

const ctx = { waitUntil() {}, passThroughOnException() {} };
const HOSTS = { LP_HOSTNAME: 'invest.example', APP_HOSTNAME: 'app.invest.example' };

function req(url, init) {
  return new Request(url, init);
}
function formPost(url, fields, accept = 'text/html') {
  const body = new URLSearchParams(fields);
  return new Request(url, {
    method: 'POST',
    headers: { 'content-type': 'application/x-www-form-urlencoded', accept },
    body,
  });
}

// ---- ホストの振り分け -------------------------------------------------------

test('ホスト名で LP とアプリを分ける', () => {
  const env = makeEnv(HOSTS);
  assert.equal(resolveSite(new URL('https://invest.example/'), env).site, 'lp');
  assert.equal(resolveSite(new URL('https://app.invest.example/'), env).site, 'app');
  assert.equal(resolveSite(new URL('https://app.invest.example/screener'), env).site, 'app');
});

test('ホスト名の大文字小文字を問わない', () => {
  const env = makeEnv(HOSTS);
  assert.equal(resolveSite(new URL('https://Invest.Example/'), env).site, 'lp');
});

test('ホスト未設定なら /lp 配下だけが LP（ローカル開発）', () => {
  const env = makeEnv();
  assert.deepEqual(resolveSite(new URL('http://localhost:8787/lp'), env), { site: 'lp', path: '/' });
  assert.deepEqual(resolveSite(new URL('http://localhost:8787/lp/privacy'), env), {
    site: 'lp',
    path: '/privacy',
  });
  assert.equal(resolveSite(new URL('http://localhost:8787/'), env).site, 'app');
  assert.equal(resolveSite(new URL('http://localhost:8787/screener'), env).site, 'app');
});

test('未知のホストはアプリ側に落とす（LP を勝手に生やさない）', () => {
  // 公開側を広げる方向に倒すと、市場データが漏れる経路になりうる。
  const env = makeEnv(HOSTS);
  assert.equal(resolveSite(new URL('https://someone-else.example/'), env).site, 'app');
});

test('末尾スラッシュを正規化する', () => {
  assert.equal(normalisePath('/screener/'), '/screener');
  assert.equal(normalisePath('/'), '/');
  assert.equal(normalisePath(''), '/');
});

test('LP のリンク接頭辞とアプリの URL', () => {
  assert.equal(lpBasePath(makeEnv()), '/lp');
  assert.equal(lpBasePath(makeEnv(HOSTS)), '');
  assert.equal(appUrl(makeEnv(), '/'), '/');
  assert.equal(appUrl(makeEnv(HOSTS), '/'), 'https://app.invest.example/');
});

// ---- LP は認証を通さない ----------------------------------------------------

test('Access を設定していても LP は認証なしで見られる', async () => {
  const env = makeEnv({
    ...HOSTS,
    CF_ACCESS_TEAM_DOMAIN: 'team.cloudflareaccess.com',
    CF_ACCESS_AUD: 'aud123',
  });
  const res = await handler.fetch(req('https://invest.example/'), env, ctx);
  assert.equal(res.status, 200);
  assert.match(res.headers.get('content-type'), /text\/html/);
});

test('同じ設定でアプリ側は 401 のまま', async () => {
  const env = makeEnv({
    ...HOSTS,
    CF_ACCESS_TEAM_DOMAIN: 'team.cloudflareaccess.com',
    CF_ACCESS_AUD: 'aud123',
  });
  const res = await handler.fetch(req('https://app.invest.example/'), env, ctx);
  assert.equal(res.status, 401);
});

test('LP は市場データの API を持たない', async () => {
  const env = makeEnv(HOSTS);
  for (const path of ['/api/ranking', '/api/symbol/JP.72030', '/screener']) {
    const res = await handler.fetch(req(`https://invest.example${path}`), env, ctx);
    assert.equal(res.status, 404, `${path} が LP 側で応答している`);
  }
});

// ---- LP の中身 --------------------------------------------------------------

test('LP に必要な要素が揃っている', async () => {
  const env = makeEnv(HOSTS);
  const html = await (await handler.fetch(req('https://invest.example/'), env, ctx)).text();
  assert.match(html, /先行登録/);
  assert.match(html, /name="email"/);
  assert.match(html, /name="consent"/);
  assert.match(html, /投資判断はご自身の責任/, '免責が必ず出る');
  assert.match(html, /勧誘するものではありません/);
  assert.match(html, /期待リターンではありません|条件への合致度/, 'スコアの意味を明示する');
  assert.match(html, /app\.invest\.example/, 'ログイン先がアプリのホストを向く');
});

test('LP は銘柄名や価格を一切含まない', async () => {
  const env = makeEnv(HOSTS);
  const html = await (await handler.fetch(req('https://invest.example/'), env, ctx)).text();
  for (const leak of ['トヨタ', 'JP.', '¥', 'BUY_NOW']) {
    assert.ok(!html.includes(leak), `LP に ${leak} が出ている`);
  }
});

test('プライバシーポリシーは未記入箇所が分かるようになっている', async () => {
  const env = makeEnv(HOSTS);
  const html = await (await handler.fetch(req('https://invest.example/privacy'), env, ctx)).text();
  assert.match(html, /\[運営者名・所在地・連絡先を記入\]/, '埋めるべき箇所が残っている');
  assert.match(html, /IP アドレスは保存していません/);
});

test('ハニーポットは画面外に隠れている', () => {
  const html = lpPage({ siteName: 'X', basePath: '', appUrl: '/' });
  assert.match(html, /class="hp"/);
  assert.match(html, /name="company"/);
  assert.match(html, /\.hp \{[^}]*left: -9999px/, '見えない位置に置く CSS が要る');
});

// ---- 先行登録 ---------------------------------------------------------------

test('メールアドレスの正規化', () => {
  assert.equal(normaliseEmail('  Foo@Example.COM '), 'foo@example.com');
  assert.equal(normaliseEmail('a@b.co.jp'), 'a@b.co.jp');
  assert.equal(normaliseEmail('no-at-sign'), null);
  assert.equal(normaliseEmail('a@b'), null, 'ドットの無いドメインは弾く');
  assert.equal(normaliseEmail('a b@c.com'), null);
  assert.equal(normaliseEmail(''), null);
  assert.equal(normaliseEmail(`${'a'.repeat(250)}@b.com`), null, '長すぎるものは弾く');
});

test('登録できて、保存される', async () => {
  const env = makeEnv(HOSTS);
  const res = await handler.fetch(
    formPost('https://invest.example/api/waitlist', { email: 'Taro@Example.com', consent: 'on' }),
    env,
    ctx,
  );
  assert.equal(res.status, 200);
  assert.match(await res.text(), /登録を受け付けました/);

  const rows = env.INVEST_DB.query('SELECT * FROM waitlist');
  assert.equal(rows.length, 1);
  assert.equal(rows[0].email, 'taro@example.com', '小文字で保存する');
  assert.equal(rows[0].status, 'pending');
  assert.ok(rows[0].consented_at, '同意した時刻を残す');
});

test('同意が無ければ受け付けない', async () => {
  const env = makeEnv(HOSTS);
  const res = await handler.fetch(
    formPost('https://invest.example/api/waitlist', { email: 'a@example.com' }),
    env,
    ctx,
  );
  assert.equal(res.status, 422);
  assert.equal(env.INVEST_DB.query('SELECT * FROM waitlist').length, 0);
});

test('形式が不正なら 422', async () => {
  const env = makeEnv(HOSTS);
  const res = await handler.fetch(
    formPost('https://invest.example/api/waitlist', { email: 'bad', consent: 'on' }),
    env,
    ctx,
  );
  assert.equal(res.status, 422);
});

test('ハニーポットが埋まっていたら、成功したふりをして捨てる', async () => {
  const env = makeEnv(HOSTS);
  const res = await handler.fetch(
    formPost('https://invest.example/api/waitlist', {
      email: 'bot@example.com',
      consent: 'on',
      company: 'Acme Inc',
    }),
    env,
    ctx,
  );
  assert.equal(res.status, 200, '弾いたことを教えない');
  assert.equal(env.INVEST_DB.query('SELECT * FROM waitlist').length, 0, '保存しない');
});

test('二重登録でも同じ応答（登録の有無を外から探れない）', async () => {
  const env = makeEnv(HOSTS);
  const send = () =>
    handler.fetch(
      formPost('https://invest.example/api/waitlist', { email: 'dup@example.com', consent: 'on' }),
      env,
      ctx,
    );
  const first = await send();
  const second = await send();
  assert.equal(first.status, second.status);
  assert.equal(env.INVEST_DB.query('SELECT * FROM waitlist').length, 1);
});

test('JSON でも受け付ける', async () => {
  const env = makeEnv(HOSTS);
  const res = await handler.fetch(
    new Request('https://invest.example/api/waitlist', {
      method: 'POST',
      headers: { 'content-type': 'application/json' },
      body: JSON.stringify({ email: 'json@example.com', consent: true }),
    }),
    env,
    ctx,
  );
  assert.equal(res.status, 200);
  assert.deepEqual(await res.json(), { ok: true });
});

test('GET では登録できない', async () => {
  const env = makeEnv(HOSTS);
  const res = await handler.fetch(req('https://invest.example/api/waitlist'), env, ctx);
  assert.equal(res.status, 405);
});

test('1 日あたりの上限を超えたら受け付けない', async () => {
  const env = makeEnv(HOSTS);
  const today = new Date().toISOString().slice(0, 10);
  for (let i = 0; i < 500; i += 1) {
    await env.INVEST_DB.prepare(
      `INSERT INTO waitlist (email, created_at, consented_at, status)
       VALUES (?1, ?2, ?2, 'pending')`,
    )
      .bind(`bulk${i}@example.com`, `${today}T00:00:00.000Z`)
      .run();
  }
  const res = await handler.fetch(
    formPost('https://invest.example/api/waitlist', { email: 'over@example.com', consent: 'on' }),
    env,
    ctx,
  );
  assert.equal(res.status, 503);
});

test('壊れた JSON でも 500 にしない', async () => {
  const env = makeEnv(HOSTS);
  const res = await handler.fetch(
    new Request('https://invest.example/api/waitlist', {
      method: 'POST',
      headers: { 'content-type': 'application/json' },
      body: '{ broken',
    }),
    env,
    ctx,
  );
  assert.equal(res.status, 400);
});
