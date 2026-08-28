import test from 'node:test';
import assert from 'node:assert/strict';
import { readdirSync, readFileSync, statSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { join } from 'node:path';

const SCRIPTS_DIR = fileURLToPath(new URL('../../../scripts', import.meta.url));
const files = readdirSync(SCRIPTS_DIR);

test('.ps1 は UTF-8 BOM 付きで保存されている', () => {
  // PowerShell 5.1 は BOM が無いと Shift-JIS として読む。
  // 日本語コメントが化けて構文エラーになり、Windows でだけ動かなくなる。
  const ps1 = files.filter((f) => f.endsWith('.ps1'));
  assert.ok(ps1.length > 0, '.ps1 が 1 つも無い');
  for (const name of ps1) {
    const bytes = readFileSync(join(SCRIPTS_DIR, name));
    assert.deepEqual(
      [...bytes.subarray(0, 3)],
      [0xef, 0xbb, 0xbf],
      `${name} に UTF-8 BOM が無い`,
    );
  }
});

test('.ps1 の中身が UTF-8 として読める', () => {
  for (const name of files.filter((f) => f.endsWith('.ps1'))) {
    const text = readFileSync(join(SCRIPTS_DIR, name), 'utf8');
    assert.ok(!text.includes('�'), `${name} に文字化けがある`);
  }
});

test('.sh は BOM を持たない（シェバンが壊れる）', () => {
  for (const name of files.filter((f) => f.endsWith('.sh'))) {
    const bytes = readFileSync(join(SCRIPTS_DIR, name));
    assert.notDeepEqual([...bytes.subarray(0, 3)], [0xef, 0xbb, 0xbf], `${name} に BOM が付いている`);
    assert.equal(bytes.subarray(0, 2).toString(), '#!', `${name} がシェバンで始まっていない`);
  }
});

test('.sh は実行権限を持つ', () => {
  for (const name of files.filter((f) => f.endsWith('.sh'))) {
    const mode = statSync(join(SCRIPTS_DIR, name)).mode;
    assert.ok((mode & 0o111) !== 0, `${name} に実行権限が無い`);
  }
});

test('.sh は set -u で未定義変数を検出する', () => {
  for (const name of files.filter((f) => f.endsWith('.sh'))) {
    const text = readFileSync(join(SCRIPTS_DIR, name), 'utf8');
    assert.match(text, /^set -[eu]/m, `${name} に set -e / set -u が無い`);
  }
});
