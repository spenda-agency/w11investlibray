/**
 * デプロイ前チェック。`npm run deploy` の直前に走る。
 *
 * **テストに入れていない理由**: `database_id` が未設定なのはローカル開発では
 * 正常な状態で、CI を赤くしてはいけない。デプロイのときだけ止めたい。
 *
 * 失敗したら「何をどう直すか」まで出す。wrangler の素のエラーは
 * 原因が読み取りにくい。
 */
import { readFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';

const CONFIG_PATH = fileURLToPath(
  new URL('../packages/worker/wrangler.toml', import.meta.url),
);
const config = readFileSync(CONFIG_PATH, 'utf8');

const errors = [];
const warnings = [];

/** `[env.production.vars]` などのテーブルをキー→値で読む。 */
function readTable(header) {
  const start = config.indexOf(`[${header}]`);
  if (start < 0) return null;
  const rest = config.slice(start + header.length + 2);
  const end = rest.search(/^\[/m);
  const body = end < 0 ? rest : rest.slice(0, end);
  const out = {};
  for (const line of body.split('\n')) {
    if (line.trim().startsWith('#')) continue;
    const m = /^\s*([A-Za-z_][A-Za-z0-9_]*)\s*=\s*"(.*)"\s*$/.exec(line);
    if (m !== null) out[m[1]] = m[2];
  }
  return out;
}

const prod = readTable('env.production.vars');
if (prod === null) {
  errors.push([
    '[env.production.vars] が見つからない',
    'wrangler.toml の本番セクションが壊れている可能性がある',
  ]);
}

// --- D1 -------------------------------------------------------------------
const prodBlock = config.slice(config.indexOf('[env.production]'));
const dbId = /\[\[env\.production\.d1_databases\]\][\s\S]*?database_id\s*=\s*"([^"]*)"/.exec(prodBlock)?.[1];
if (dbId === undefined) {
  errors.push([
    '本番の database_id が見つからない',
    '[[env.production.d1_databases]] に database_id を書く',
  ]);
} else if (dbId.startsWith('REPLACE_WITH') || dbId.trim() === '') {
  errors.push([
    'database_id が未設定（プレースホルダのまま）',
    'npx wrangler d1 create invest-db を実行し、出力された id を\n' +
      '    wrangler.toml の [[env.production.d1_databases]] に貼る',
  ]);
}

// --- ホスト名とルート -------------------------------------------------------
if (prod !== null) {
  for (const key of ['LP_HOSTNAME', 'APP_HOSTNAME']) {
    if (!prod[key]) {
      errors.push([
        `本番の ${key} が空`,
        `wrangler.toml の [env.production.vars] に ${key} を設定する`,
      ]);
    }
  }
  if (prod['LP_HOSTNAME'] && prod['LP_HOSTNAME'] === prod['APP_HOSTNAME']) {
    errors.push([
      'LP とアプリのホスト名が同じ',
      'Access の適用範囲が分けられなくなる。別ホストにする',
    ]);
  }

  const patterns = [...prodBlock.matchAll(/^pattern = "([^"]+)"/gm)].map((m) => m[1]);
  for (const key of ['LP_HOSTNAME', 'APP_HOSTNAME']) {
    const host = prod[key];
    if (host && !patterns.includes(`${host}/*`)) {
      errors.push([
        `${host} のルートが無い`,
        `[[env.production.routes]] に pattern = "${host}/*" を足す`,
      ]);
    }
  }

  // --- Access（警告どまり）--------------------------------------------------
  if (!prod['CF_ACCESS_TEAM_DOMAIN'] || !prod['CF_ACCESS_AUD']) {
    warnings.push([
      'Cloudflare Access が未設定',
      'ダッシュボードが誰でも見られる状態になる。\n' +
        '    Access をかける前に一度デプロイしたいだけなら、このままでよい。\n' +
        '    手順は docs/DEPLOY.md の 9',
    ]);
  }
  if (prod['MEMBER_SIGNUP_ENABLED'] === 'true') {
    warnings.push([
      '会員登録が開いている',
      'docs/DATA-SOURCES.md の「再配信の可否」が埋まっているか確認する',
    ]);
  }
}

// --- workers.dev -----------------------------------------------------------
if (/^\s*workers_dev\s*=\s*true/m.test(config)) {
  errors.push([
    'workers_dev = true になっている',
    'Access はゾーンのホスト名に紐づくので、*.workers.dev には適用されない。\n' +
      '    その URL でダッシュボードが認証なしに開く。false にする',
  ]);
}

// --- 出力 -------------------------------------------------------------------
for (const [title, how] of warnings) {
  console.error(`⚠ ${title}\n    ${how}`);
}
if (errors.length === 0) {
  console.error(`✓ デプロイ前チェック通過${warnings.length > 0 ? `（警告 ${warnings.length} 件）` : ''}`);
  process.exit(0);
}
console.error('');
for (const [title, how] of errors) {
  console.error(`✗ ${title}\n    ${how}`);
}
console.error(`\n${errors.length} 件を直してから deploy すること。`);
process.exit(1);
