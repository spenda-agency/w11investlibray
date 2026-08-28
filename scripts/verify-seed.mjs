/**
 * サンプルデータが本物のスキーマに投入できるかを CI で確かめる。
 *
 * seed が壊れていると `npm run db:seed:local` が失敗し、
 * 「まず動かして見る」ができなくなる。気付くのは遅いほど痛い。
 */
import { DatabaseSync } from 'node:sqlite';
import { readFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';

const schema = fileURLToPath(new URL('../migrations/0001_init.sql', import.meta.url));
const seed = fileURLToPath(new URL('../packages/worker/seed/sample.sql', import.meta.url));

const db = new DatabaseSync(':memory:');
db.exec('PRAGMA foreign_keys = ON');
db.exec(readFileSync(schema, 'utf8'));
db.exec(readFileSync(seed, 'utf8'));

const counts = db
  .prepare(
    `SELECT (SELECT COUNT(*) FROM symbols) AS symbols,
            (SELECT COUNT(*) FROM prices_daily) AS prices,
            (SELECT COUNT(*) FROM indicators_daily) AS indicators,
            (SELECT COUNT(*) FROM signals_daily) AS signals,
            (SELECT COUNT(*) FROM scores_daily) AS scores`,
  )
  .get();

const problems = [];
for (const [key, value] of Object.entries(counts)) {
  if (value === 0) problems.push(`${key} が 0 件`);
}

// スコアが 0〜100 に収まっているか
const bad = db
  .prepare(`SELECT COUNT(*) AS n FROM scores_daily WHERE total IS NOT NULL AND (total < 0 OR total > 100)`)
  .get();
if (bad.n > 0) problems.push(`範囲外のスコアが ${bad.n} 件`);

// 判定が 4 値のいずれかか
const verdicts = db
  .prepare(`SELECT DISTINCT verdict AS v FROM scores_daily`)
  .all()
  .map((r) => r.v);
const allowed = new Set(['BUY_NOW', 'BUY_WATCH', 'WATCH', 'AVOID']);
for (const v of verdicts) if (!allowed.has(v)) problems.push(`想定外の verdict: ${v}`);

// サンプルであることの印が入っているか
const marker = db.prepare(`SELECT COUNT(*) AS n FROM job_runs WHERE job = 'sample_seed'`).get();
if (marker.n === 0) problems.push('sample_seed の印が無い（画面に警告が出ない）');

if (problems.length > 0) {
  console.error('サンプルデータの検証に失敗:');
  for (const p of problems) console.error(`  - ${p}`);
  process.exit(1);
}

console.log('サンプルデータ OK:', JSON.stringify(counts), '/ verdict:', verdicts.join(', '));
