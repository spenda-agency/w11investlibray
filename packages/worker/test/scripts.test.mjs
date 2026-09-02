import test from 'node:test';
import assert from 'node:assert/strict';
import { readdirSync, readFileSync, statSync } from 'node:fs';
import { applyDatabaseId, extractDatabaseId } from '../../../scripts/set-database-id.mjs';
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

// ---- database_id の書き込み -------------------------------------------------

/** `wrangler d1 create invest-db` が実際に返す形。 */
const WRANGLER_OUTPUT = `
 ⛅️ wrangler 4.125.0
─────────────────────
✅ Successfully created DB 'invest-db' in region APAC
Created your new D1 database.

[[d1_databases]]
binding = "INVEST_DB"
database_name = "invest-db"
database_id = "a1b2c3d4-5e6f-7890-abcd-ef1234567890"
`;

test('wrangler の出力をまるごと渡しても id を拾う', () => {
  // 出力をコピーして貼るのが自然な操作なので、そこから拾えないと意味がない。
  const got = extractDatabaseId(WRANGLER_OUTPUT);
  assert.equal(got.ok, true);
  assert.equal(got.id, 'a1b2c3d4-5e6f-7890-abcd-ef1234567890');

  // id だけ渡しても同じ
  assert.equal(extractDatabaseId('  A1B2C3D4-5E6F-7890-ABCD-EF1234567890 ').id,
    'a1b2c3d4-5e6f-7890-abcd-ef1234567890', '大文字でも小文字に寄せる');
});

test('UUID が 2 種類あったら選ばない', () => {
  // 貼り間違いを黙って通すほうが害が大きい。
  const two = extractDatabaseId(
    'a1b2c3d4-5e6f-7890-abcd-ef1234567890 と 11111111-2222-3333-4444-555555555555',
  );
  assert.equal(two.ok, false);
  assert.match(two.reason, /2 個/);

  assert.equal(extractDatabaseId('id はまだ無い').ok, false);
});

test('database_id を 2 箇所とも書き換える', () => {
  // 既定側（wrangler dev 用）と [[env.production.d1_databases]] の両方。
  // preflight は本番側しか見ないので、既定側を取りこぼすと黙って通る。
  const config = readFileSync(
    fileURLToPath(new URL('../wrangler.toml', import.meta.url)),
    'utf8',
  );
  assert.equal(
    (config.match(/^\s*database_id\s*=/gm) ?? []).length,
    2,
    'wrangler.toml の database_id が 2 箇所でなくなっている',
  );

  const id = 'a1b2c3d4-5e6f-7890-abcd-ef1234567890';
  const { text, count, changed } = applyDatabaseId(config, id);
  assert.equal(count, 2);
  assert.equal(changed, true);
  assert.equal((text.match(new RegExp(id, 'g')) ?? []).length, 2);
  assert.ok(!text.includes('REPLACE_WITH'), 'プレースホルダが残っている');

  // 同じ id をもう一度当てても変わらない（冪等）
  assert.equal(applyDatabaseId(text, id).changed, false);
});
