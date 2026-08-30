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

test('未知のホストには何も返さない', () => {
  // 当初は「未知のホストはアプリ側に落とす」ことにしていたが、これは誤り。
  // Cloudflare Access はゾーンのホスト名に紐づくため、別ホストから来た
  // リクエストには適用されない。アプリを返すと認証を通らずに開いてしまう。
  const env = makeEnv(HOSTS);
  assert.equal(resolveSite(new URL('https://someone-else.example/'), env).site, 'unknown');
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
  const html = lpPage({ siteName: 'X', shortName: 'X', basePath: '', appUrl: '/' });
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

// ---- 想定外のホストとリダイレクト ---------------------------------------

test('ホスト設定済みなら、一致しないホストにはアプリを返さない', async () => {
  // Cloudflare Access はゾーンのホスト名に紐づく。*.workers.dev のような
  // 別ホストから来たリクエストには適用されないので、ここでアプリを返すと
  // 認証を通らずにダッシュボードが開く。
  const env = makeEnv(HOSTS);
  for (const host of [
    'https://w11-invest-library.someone.workers.dev/',
    'https://random.example/',
    'https://goldencross-incomegains.com.evil.example/',
  ]) {
    const res = await handler.fetch(req(host), env, ctx);
    assert.equal(res.status, 404, `${host} が応答している`);
  }
});

test('resolveSite — 設定済みで一致しなければ unknown', () => {
  const env = makeEnv(HOSTS);
  assert.equal(resolveSite(new URL('https://nope.example/'), env).site, 'unknown');
  // 片方だけ設定されていても本番扱いにする
  const half = makeEnv({ LP_HOSTNAME: 'invest.example', APP_HOSTNAME: '' });
  assert.equal(resolveSite(new URL('https://nope.example/'), half).site, 'unknown');
});

test('ホスト未設定のローカルでは、これまで通りパスで振り分ける', () => {
  const env = makeEnv();
  assert.equal(resolveSite(new URL('http://localhost:8787/'), env).site, 'app');
  assert.equal(resolveSite(new URL('http://localhost:8787/lp'), env).site, 'lp');
});

test('www は apex へ 301 で寄せる', async () => {
  const env = makeEnv(HOSTS);
  const res = await handler.fetch(req('https://www.invest.example/privacy?a=1'), env, ctx);
  assert.equal(res.status, 301);
  assert.equal(res.headers.get('location'), 'https://invest.example/privacy?a=1');

  const app = await handler.fetch(req('https://www.app.invest.example/screener'), env, ctx);
  assert.equal(app.status, 301);
  assert.equal(app.headers.get('location'), 'https://app.invest.example/screener');
});

// ---- 検索エンジン向け -------------------------------------------------------

test('LP の robots.txt は索引を許し、sitemap を指す', async () => {
  const env = makeEnv(HOSTS);
  const res = await handler.fetch(req('https://invest.example/robots.txt'), env, ctx);
  assert.equal(res.status, 200);
  const body = await res.text();
  assert.match(body, /Allow: \//);
  assert.match(body, /Sitemap: https:\/\/invest\.example\/sitemap\.xml/);
});

test('アプリ側の robots.txt は全面拒否', async () => {
  const env = makeEnv(HOSTS);
  const res = await handler.fetch(req('https://app.invest.example/robots.txt'), env, ctx);
  assert.equal(res.status, 200, '認証より手前で返す');
  assert.match(await res.text(), /Disallow: \//);
});

test('sitemap.xml が LP のページを列挙する', async () => {
  const env = makeEnv(HOSTS);
  const res = await handler.fetch(req('https://invest.example/sitemap.xml'), env, ctx);
  assert.equal(res.status, 200);
  assert.match(res.headers.get('content-type'), /application\/xml/);
  const body = await res.text();
  assert.match(body, /<loc>https:\/\/invest\.example\/<\/loc>/);
  assert.match(body, /<loc>https:\/\/invest\.example\/privacy<\/loc>/);
  // ダッシュボードの URL を混ぜない
  assert.ok(!body.includes('app.invest.example'));
});

test('LP に canonical と og:url が入る', async () => {
  const env = makeEnv(HOSTS);
  const html = await (await handler.fetch(req('https://invest.example/'), env, ctx)).text();
  assert.match(html, /<link rel="canonical" href="https:\/\/invest\.example\/">/);
  assert.match(html, /<meta property="og:url" content="https:\/\/invest\.example\/">/);
});

test('ローカルでは canonical を出さない（localhost を指してしまうため）', async () => {
  const env = makeEnv();
  const html = await (await handler.fetch(req('http://localhost:8787/lp'), env, ctx)).text();
  assert.ok(!html.includes('rel="canonical"'));
});

test('LP は noindex にしない（ダッシュボードは noindex のまま）', async () => {
  const env = makeEnv(HOSTS);
  const lp = await (await handler.fetch(req('https://invest.example/'), env, ctx)).text();
  assert.ok(!lp.includes('noindex'), 'LP は索引させる');
});

test('本番のホスト名を設定していても localhost では開発用に振り分ける', () => {
  // wrangler.toml に本番のホスト名が入った状態で `wrangler dev` が
  // 全部 404 になった（実際にやらかした）。ループバックは常に開発扱いにする。
  const env = makeEnv({
    LP_HOSTNAME: 'goldencross-incomegains.com',
    APP_HOSTNAME: 'app.goldencross-incomegains.com',
  });
  assert.equal(resolveSite(new URL('http://localhost:8787/'), env).site, 'app');
  assert.equal(resolveSite(new URL('http://localhost:8787/lp'), env).site, 'lp');
  assert.equal(resolveSite(new URL('http://127.0.0.1:8787/screener'), env).site, 'app');
  assert.equal(resolveSite(new URL('http://app.localhost:8787/'), env).site, 'app');
});

// ---- 長いサイト名の扱い -----------------------------------------------------

test('LP の title は正式名だけで、検索結果に収まる長さ', () => {
  // 正式名は 24 文字。ここにキャッチコピーを足すと 42 文字になり、
  // 検索結果（全角 30 文字前後で切られる）で後半が丸ごと消える。
  const full = 'ゴールデンクロスーインカムゲインを究める資産運用';
  const html = lpPage({ siteName: full, shortName: 'ゴールデンクロス', basePath: '', appUrl: '/' });
  const title = /<title>([^<]*)<\/title>/.exec(html)?.[1];
  assert.equal(title, full, 'title は正式名だけにする');
  assert.ok(title.length <= 32, `title が ${title.length} 文字ある`);
});

test('LP のヘッダーには短縮名が出る', () => {
  const html = lpPage({
    siteName: 'ゴールデンクロスーインカムゲインを究める資産運用',
    shortName: 'ゴールデンクロス',
    basePath: '',
    appUrl: '/',
  });
  const brand = /<span class="brand">([^<]*)<\/span>/.exec(html)?.[1];
  assert.equal(brand, 'ゴールデンクロス', '狭い画面で折り返さないよう短縮名を使う');
});

test('og:title は正式名（共有時に何のサービスか分かるように）', () => {
  const full = 'ゴールデンクロスーインカムゲインを究める資産運用';
  const html = lpPage({ siteName: full, shortName: '短', basePath: '', appUrl: '/' });
  assert.ok(html.includes(`<meta property="og:title" content="${full}">`));
});

test('ダッシュボードの title とヘッダーは短縮名', async () => {
  const env = makeEnv(HOSTS);
  const html = await (await handler.fetch(req('https://app.invest.example/'), env, ctx)).text();
  const title = /<title>([^<]*)<\/title>/.exec(html)?.[1];
  assert.match(title, /ゴールデンクロス$/);
  assert.ok(title.length <= 32, `title が ${title.length} 文字ある`);
  assert.ok(!title.includes('資産運用'), 'ダッシュボードのタブに正式名を出さない');
});

test('プライバシーポリシーの title も短縮名で組む', async () => {
  const env = makeEnv(HOSTS);
  const html = await (await handler.fetch(req('https://invest.example/privacy'), env, ctx)).text();
  const title = /<title>([^<]*)<\/title>/.exec(html)?.[1];
  assert.equal(title, 'プライバシーポリシー — ゴールデンクロス');
  assert.ok(title.length <= 32, `title が ${title.length} 文字ある`);
});
