/**
 * Node 側の J-Quants クライアント。
 *
 * Worker 側（`packages/worker/src/connectors/jquants.ts`）と別実装になっているのは、
 * Worker のコードが `@cloudflare/workers-types` に依存していて Node から読めないため。
 * **ただし項目名の別名表はここが持ち、Worker とは独立に動く。**
 * 別名を足すときは両方に入れること（`npm run check` の出力をそのまま貼れる形にしてある）。
 *
 * 計算（指標・スコア・バックテスト）は共有していて、そちらは `@invest/core` の 1 本だけ。
 * ここで重複しているのは HTTP の取り回しだけで、検証の意味は損なわれない。
 */

export const DEFAULT_BASE_URL = 'https://api.jquants.com/v2';

/**
 * V2 の経路。**V1 とは名前がまったく違う。**
 *
 *   /listed/info              → /equities/master
 *   /prices/daily_quotes      → /equities/bars/daily
 *   /markets/trading_calendar → /markets/calendar
 *
 * V1 の名前のまま /v2 に投げると、API Gateway が経路なしとして **403** を返す。
 * 「契約プランの範囲外」に見えるので、原因に辿り着くまで遠回りした。
 * 出典は本番運用中の実装（spenda-agency/w09jquantsclaude の
 * `src/jqsd/jquants.py`）。**推測で書かないこと。**
 *
 * Worker 側（packages/worker/src/connectors/jquants.ts の JP_PATHS）と
 * 同じ値を持つ。**片方だけ直すと本番とバックフィルがずれる。**
 */
export const JP_PATHS = {
  master: '/equities/master',
  dailyBars: '/equities/bars/daily',
  calendar: '/markets/calendar',
} as const;

export const FIELD_ALIASES: Readonly<Record<string, readonly string[]>> = {
  date: ['Date', 'date', 'Dt'],
  code: ['Code', 'code', 'Cd'],
  open: ['Open', 'O', 'AdjustmentOpen'],
  high: ['High', 'H', 'AdjustmentHigh'],
  low: ['Low', 'L', 'AdjustmentLow'],
  close: ['Close', 'C', 'AdjustmentClose'],
  volume: ['Volume', 'V', 'Vo', 'AdjustmentVolume'],
  turnover: ['TurnoverValue', 'Va', 'TurnoverVa', 'TuVa', 'Turnover'],
  adjustmentFactor: ['AdjustmentFactor', 'AdjFactor', 'AdjustmentF', 'AdjFa', 'AdjF'],
  companyName: ['CoName', 'CompanyName', 'CompanyNameJapanese', 'Name', 'Nm', 'CoNm'],
  sector33: ['S33Nm', 'S33', 'Sector33CodeName', 'Sector33Code', 'Sc33Nm'],
  sector17: ['S17Nm', 'S17', 'Sector17CodeName', 'Sector17Code', 'Sc17Nm'],
  holidayDivision: ['HolDiv', 'HolidayDivision', 'HolidayDiv', 'HdDiv'],
};

export type Row = Record<string, unknown>;

export interface FetchPage {
  readonly rows: Row[];
  readonly status: number;
}

export class Jquants {
  constructor(
    private readonly apiKey: string,
    private readonly baseUrl: string = DEFAULT_BASE_URL,
    private readonly extraAliases: Record<string, readonly string[]> = {},
  ) {
    if (!apiKey) throw new Error('JQUANTS_API_KEY が未設定');
  }

  /** 生の 1 ページ。`check` が状態コードを見たいので分けてある。 */
  async probe(path: string, params: Record<string, string>): Promise<{ status: number; body: unknown }> {
    const url = new URL(`${this.baseUrl}${path}`);
    for (const [k, v] of Object.entries(params)) url.searchParams.set(k, v);
    const res = await fetch(url, { headers: { 'x-api-key': this.apiKey, accept: 'application/json' } });
    const text = await res.text();
    let body: unknown;
    try {
      body = JSON.parse(text);
    } catch {
      body = text.slice(0, 300);
    }
    return { status: res.status, body };
  }

  /**
   * **レコードは `data` キーに入る。** V1 は経路ごとに違うキーだったが、
   * V2 は全経路 `data` で揃っている。既定値にしてあるのは、
   * また変わったときに 1 箇所で受けられるようにするため。
   */
  async getAll(path: string, params: Record<string, string>, key = 'data'): Promise<Row[]> {
    const rows: Row[] = [];
    let paginationKey: string | undefined;
    for (let page = 0; page < 200; page += 1) {
      const url = new URL(`${this.baseUrl}${path}`);
      for (const [k, v] of Object.entries(params)) url.searchParams.set(k, v);
      if (paginationKey !== undefined) url.searchParams.set('pagination_key', paginationKey);

      const res = await fetch(url, { headers: { 'x-api-key': this.apiKey, accept: 'application/json' } });
      if (res.status === 429) {
        // レート制限。素直に待って同じページをやり直す。
        await sleep(5000);
        continue;
      }
      if (!res.ok) {
        throw new Error(`J-Quants ${path} が ${res.status}: ${(await res.text()).slice(0, 200)}`);
      }
      const json = (await res.json()) as Record<string, unknown>;
      const chunk = json[key];
      if (Array.isArray(chunk)) rows.push(...(chunk as Row[]));
      const next = json['pagination_key'];
      if (typeof next !== 'string' || next === '') break;
      paginationKey = next;
    }
    return rows;
  }

  field(row: Row, canonical: string): unknown {
    const candidates = [...(this.extraAliases[canonical] ?? []), ...(FIELD_ALIASES[canonical] ?? [])];
    for (const name of candidates) {
      const v = row[name];
      if (v !== undefined && v !== null && v !== '') return v;
    }
    return undefined;
  }

  numberOf(row: Row, canonical: string): number | null {
    const v = this.field(row, canonical);
    const n = typeof v === 'number' ? v : typeof v === 'string' ? Number(v) : NaN;
    return Number.isFinite(n) ? n : null;
  }

  stringOf(row: Row, canonical: string): string | null {
    const v = this.field(row, canonical);
    if (typeof v === 'string' && v !== '') return v;
    if (typeof v === 'number') return String(v);
    return null;
  }
}

export function sleep(ms: number): Promise<void> {
  return new Promise((resolve) => setTimeout(resolve, ms));
}
