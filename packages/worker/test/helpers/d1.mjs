import { DatabaseSync } from 'node:sqlite';
import { readFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';

/**
 * D1 の薄いシム（node:sqlite の上に載せる）。
 *
 * SQL を実際に走らせずにモックで済ませると、プレースホルダの取り違えや
 * インデックスの効かない JOIN が本番まで残る。ここでは本物の SQLite に
 * 本物のスキーマを流して検証する。
 */
class Stmt {
  constructor(db, sql) {
    this.db = db;
    this.sql = sql;
    this.params = [];
  }
  bind(...params) {
    const next = new Stmt(this.db, this.sql);
    next.params = params.map(normalise);
    return next;
  }
  #prepared() {
    return this.db.prepare(this.sql);
  }
  async all() {
    return { results: this.#prepared().all(...this.params), success: true };
  }
  async first() {
    const row = this.#prepared().get(...this.params);
    return row === undefined ? null : row;
  }
  async run() {
    const info = this.#prepared().run(...this.params);
    return { success: true, meta: { changes: info.changes } };
  }
}

function normalise(v) {
  if (v === undefined) return null;
  if (typeof v === 'boolean') return v ? 1 : 0;
  return v;
}

export class FakeD1 {
  constructor(schemaPath) {
    this.db = new DatabaseSync(':memory:');
    this.db.exec('PRAGMA foreign_keys = ON');
    this.db.exec(readFileSync(schemaPath, 'utf8'));
  }
  prepare(sql) {
    return new Stmt(this.db, sql);
  }
  async batch(statements) {
    const out = [];
    for (const s of statements) out.push(await s.run());
    return out;
  }
  /** テストから直接 SQL を投げる口。 */
  exec(sql) {
    this.db.exec(sql);
  }
  query(sql, ...params) {
    return this.db.prepare(sql).all(...params);
  }
}

/** R2 のシム。put されたものを Map に貯める。 */
export class FakeR2 {
  constructor() {
    this.objects = new Map();
  }
  async put(key, value) {
    this.objects.set(key, value);
    return { key };
  }
  async get(key) {
    const v = this.objects.get(key);
    return v === undefined ? null : { text: async () => v };
  }
}

export const SCHEMA_PATH = fileURLToPath(
  new URL('../../../../migrations/0001_init.sql', import.meta.url),
);

export function makeEnv(overrides = {}) {
  return {
    INVEST_DB: new FakeD1(SCHEMA_PATH),
    INVEST_R2: new FakeR2(),
    SITE_NAME: 'Invest Library',
    MARKETS: 'JP',
    UNIVERSE_LIMIT: '500',
    NEWS_MODEL: 'test-model',
    MEMBER_SIGNUP_ENABLED: 'false',
    CF_ACCESS_TEAM_DOMAIN: '',
    CF_ACCESS_AUD: '',
    JQUANTS_BASE_URL: 'https://api.example.test/v2',
    JQUANTS_FIELD_ALIASES: '{}',
    JQUANTS_API_KEY: 'test-key',
    ...overrides,
  };
}
