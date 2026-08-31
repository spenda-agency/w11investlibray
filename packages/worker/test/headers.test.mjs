import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync, readdirSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { join } from 'node:path';
import { handler, CSP, SECURITY_HEADERS, withSecurityHeaders } from '../.build/worker.mjs';
import { makeEnv } from './helpers/d1.mjs';

const ctx = { waitUntil() {}, passThroughOnException() {} };
const HOSTS = { LP_HOSTNAME: 'invest.example', APP_HOSTNAME: 'app.invest.example' };
const req = (u, init) => new Request(u, init);

test('公開ページに保安ヘッダーが付く', async () => {
  const env = makeEnv(HOSTS);
  const res = await handler.fetch(req('https://invest.example/'), env, ctx);
  assert.equal(res.status, 200);
  for (const key of Object.keys(SECURITY_HEADERS)) {
    assert.ok(res.headers.get(key), `${key} が無い`);
  }
  assert.equal(res.headers.get('x-content-type-options'), 'nosniff');
  assert.equal(res.headers.get('x-frame-options'), 'DENY');
  assert.match(res.headers.get('strict-transport-security'), /max-age=\d+/);
});

test('script-src は none のまま（JS を足していない証拠）', () => {
  // このサイトに JavaScript は 1 行も無い。LP のフォームは JS 無しで動き、
  // スパークラインはインライン SVG 要素。かなり強い防御なので固定する。
  // 後から不用意に <script> を足せばここが落ちる。
  assert.match(CSP, /script-src 'none'/);
  assert.match(CSP, /default-src 'none'/);
  assert.match(CSP, /frame-ancestors 'none'/);
  assert.match(CSP, /form-action 'self'/);
  assert.match(CSP, /base-uri 'none'/);
});

test('実際に配信している HTML に script タグが無い', () => {
  // CSP を守れているかを、出力そのものでも確かめる。
  const uiDir = fileURLToPath(new URL('../src/ui', import.meta.url));
  for (const name of readdirSync(uiDir).filter((f) => f.endsWith('.ts'))) {
    const source = readFileSync(join(uiDir, name), 'utf8');
    assert.ok(!/<script[\s>]/i.test(source), `${name} に <script> がある`);
  }
});

test('ダッシュボードにも付く', async () => {
  const env = makeEnv();
  const res = await handler.fetch(req('http://localhost:8787/'), env, ctx);
  assert.ok(res.headers.get('content-security-policy'));
  assert.equal(res.headers.get('referrer-policy'), 'strict-origin-when-cross-origin');
});

test('エラー応答にも付く', async () => {
  const env = makeEnv(HOSTS);
  for (const url of ['https://invest.example/nope', 'https://random.example/']) {
    const res = await handler.fetch(req(url), env, ctx);
    assert.ok(res.status >= 400);
    assert.ok(res.headers.get('content-security-policy'), `${url} に CSP が無い`);
  }
});

test('リダイレクトは素通しする', async () => {
  const env = makeEnv(HOSTS);
  const res = await handler.fetch(req('https://www.invest.example/'), env, ctx);
  assert.equal(res.status, 301);
  assert.equal(res.headers.get('location'), 'https://invest.example/');
});

test('既にあるヘッダーを上書きしない', () => {
  const original = new Response('x', {
    headers: { 'content-security-policy': "default-src 'self'", 'content-type': 'text/plain' },
  });
  const wrapped = withSecurityHeaders(original);
  assert.equal(wrapped.headers.get('content-security-policy'), "default-src 'self'");
  assert.equal(wrapped.headers.get('x-content-type-options'), 'nosniff', '無いものは足す');
});

test('本文と状態コードを保つ', async () => {
  const wrapped = withSecurityHeaders(new Response('こんにちは', { status: 418 }));
  assert.equal(wrapped.status, 418);
  assert.equal(await wrapped.text(), 'こんにちは');
});

test('content-type を壊さない', async () => {
  const env = makeEnv(HOSTS);
  const checks = [
    ['https://invest.example/', /text\/html/],
    ['https://invest.example/robots.txt', /text\/plain/],
    ['https://invest.example/sitemap.xml', /application\/xml/],
  ];
  for (const [url, expected] of checks) {
    const res = await handler.fetch(req(url), env, ctx);
    assert.match(res.headers.get('content-type'), expected, url);
  }
});
