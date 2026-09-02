/**
 * `wrangler d1 create invest-db` が返した id を wrangler.toml に書き込む。
 *
 *   npx wrangler d1 create invest-db          # 出力をコピー
 *   npm run set:db-id -- 'a1b2c3d4-…'         # id だけ渡す
 *   npx wrangler d1 create invest-db | npm run set:db-id   # 出力をそのまま流す
 *
 * **なぜスクリプトにしたか。** 貼り先が 2 箇所ある（既定と [env.production]）。
 * `preflight` は本番側しか見ないので、既定側の打ち間違いは黙って通る。
 * UUID を手で 2 回写す作業をなくす。
 */
import { readFileSync, writeFileSync } from 'node:fs';
import { fileURLToPath, pathToFileURL } from 'node:url';

const UUID = /[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/gi;

/**
 * 入力から UUID を 1 つ取り出す。
 *
 * wrangler の出力をまるごと貼っても拾えるようにしてある（それが自然な操作）。
 * **2 種類以上あったら選ばない。** 貼り間違いを黙って通すほうが害が大きい。
 */
export function extractDatabaseId(input) {
  const found = [...new Set((input.match(UUID) ?? []).map((s) => s.toLowerCase()))];
  if (found.length === 0) {
    return { ok: false, reason: 'UUID が見つからない' };
  }
  if (found.length > 1) {
    return { ok: false, reason: `UUID が ${found.length} 個ある: ${found.join(', ')}` };
  }
  return { ok: true, id: found[0] };
}

/**
 * wrangler.toml の `database_id` を**すべて**書き換える。
 *
 * このファイルの `database_id` は D1 の 2 ブロックにしか無い
 * （既定と `[[env.production.d1_databases]]`）。両方を同じ id にする。
 */
export function applyDatabaseId(config, id) {
  let count = 0;
  const text = config.replace(
    /^(\s*database_id\s*=\s*)"[^"]*"/gm,
    (_match, head) => {
      count += 1;
      return `${head}"${id}"`;
    },
  );
  return { text, count, changed: text !== config };
}

const CONFIG_PATH = fileURLToPath(
  new URL('../packages/worker/wrangler.toml', import.meta.url),
);

async function readStdin() {
  if (process.stdin.isTTY) return '';
  const chunks = [];
  for await (const chunk of process.stdin) chunks.push(chunk);
  return Buffer.concat(chunks).toString('utf8');
}

async function main() {
  const fromArgs = process.argv.slice(2).join(' ').trim();
  const input = fromArgs || (await readStdin());

  if (!input.trim()) {
    console.error(
      'id を渡すこと。\n' +
        "  npm run set:db-id -- 'a1b2c3d4-5e6f-7890-abcd-ef1234567890'\n" +
        '  npx wrangler d1 create invest-db | npm run set:db-id\n' +
        '（wrangler の出力をまるごと貼っても拾う）',
    );
    process.exit(1);
  }

  const parsed = extractDatabaseId(input);
  if (!parsed.ok) {
    console.error(`✗ ${parsed.reason}`);
    console.error('    書き込んでいない。渡した内容を確かめること。');
    process.exit(1);
  }

  const before = readFileSync(CONFIG_PATH, 'utf8');
  const { text, count, changed } = applyDatabaseId(before, parsed.id);

  if (count !== 2) {
    console.error(`✗ database_id が ${count} 箇所しか見つからない（2 箇所のはず）`);
    console.error('    wrangler.toml の構成が変わっている。書き込んでいない。');
    process.exit(1);
  }

  if (!changed) {
    console.error(`✓ 変更なし（すでに ${parsed.id} が入っている）`);
    process.exit(0);
  }

  writeFileSync(CONFIG_PATH, text);
  console.error(`✓ database_id を 2 箇所に書き込んだ: ${parsed.id}`);
  console.error('    次は npm run db:migrate:remote -w @invest/worker');
}

// **`import.meta.url` で比較する。** `argv[1].includes('set-database-id')` にすると
// テストファイル名にも当たって、テスト中に main() が走る（このリポジトリで一度やった）。
if (process.argv[1] !== undefined && import.meta.url === pathToFileURL(process.argv[1]).href) {
  await main();
}
