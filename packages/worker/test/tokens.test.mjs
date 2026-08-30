import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync, readdirSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { join } from 'node:path';
import { TOKENS, FONT_STACK, layout, lpPage } from '../.build/worker.mjs';

const UI_DIR = fileURLToPath(new URL('../src/ui', import.meta.url));

/** 役割で名前を付けた共有パレット。ここに挙げたものは tokens.ts だけが定義する。 */
const SHARED_TOKENS = [
  '--bg', '--panel', '--ink', '--muted', '--line',
  '--accent', '--danger', '--warn', '--up', '--down', '--radius',
];

test('共有パレットは tokens.ts だけが定義する', () => {
  // 2 箇所に分かれていると、配色を変えたときに片方だけ取り残される。
  // LP とダッシュボードで色がずれるのがいちばん見苦しい壊れ方。
  const others = readdirSync(UI_DIR).filter((f) => f.endsWith('.ts') && f !== 'tokens.ts');
  assert.ok(others.length > 0, 'ui/ に他のファイルが無い');

  for (const name of others) {
    const source = readFileSync(join(UI_DIR, name), 'utf8');
    for (const token of SHARED_TOKENS) {
      // `--accent: #...` のような「定義」を探す。`var(--accent)` の参照は許す。
      const defines = new RegExp(`${token}\\s*:\\s*[^;\\n)]`).test(source);
      assert.ok(!defines, `${name} が ${token} を定義している。tokens.ts に寄せること`);
    }
  }
});

test('tokens.ts は明暗の両方を定義している', () => {
  for (const token of SHARED_TOKENS) {
    assert.ok(TOKENS.includes(`${token}:`), `${token} が tokens.ts に無い`);
  }
  assert.match(TOKENS, /prefers-color-scheme: dark/);

  // ダークで上書きしていない色があると、暗い地に明るい前提の色が残る。
  const dark = TOKENS.slice(TOKENS.indexOf('prefers-color-scheme: dark'));
  for (const token of ['--bg', '--panel', '--ink', '--muted', '--line', '--accent', '--danger']) {
    assert.ok(dark.includes(`${token}:`), `${token} がダークで上書きされていない`);
  }
});

test('LP とダッシュボードが同じパレットを配信する', () => {
  const app = layout({ title: 't', siteName: 's', body: '<p>x</p>' });
  const lp = lpPage({ siteName: 's', shortName: 's', basePath: '', appUrl: '/' });
  for (const page of [app, lp]) {
    assert.ok(page.includes('--accent: #'), 'パレットが出力に含まれていない');
    assert.ok(page.includes(FONT_STACK), '書体が出力に含まれていない');
  }
  // 同じ値が出ていること（片方だけ古い色になっていないこと）
  const pick = (html) => /--accent:\s*(#[0-9a-f]{6})/i.exec(html)?.[1];
  assert.equal(pick(app), pick(lp));
});

test('パレットは 1 ページにつき 1 回だけ出る', () => {
  const lp = lpPage({ siteName: 's', shortName: 's', basePath: '', appUrl: '/' });
  const count = (lp.match(/--accent:\s*#/g) ?? []).length;
  // ライト 1 回 + ダーク 1 回
  assert.equal(count, 2, `--accent の定義が ${count} 回出ている`);
});
