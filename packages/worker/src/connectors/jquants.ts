import type { CalendarRow, MarketDataSource, PriceRow, SymbolRow } from '@invest/core';
import { toSymbolId } from '@invest/core';
import type { Env } from '../types.js';

/**
 * J-Quants API V2 のクライアント。
 *
 * V1 は 2026-06-01 に提供終了済み。V2 は `x-api-key` ヘッダで認証する。
 *
 * **項目名のゆらぎをここで吸収する。** V2 で項目名が短縮された（`Close` → `C` など）が、
 * 短縮名は変わりうるし、プランによって返る項目も違う。モデル側のコードが
 * 名前の揺れに影響されないよう、正準名へ寄せる層をここに 1 枚挟む。
 * 当たらない名前が出たら `npm run check:datasource` が実際に返ってきた
 * 項目名を出すので、`JQUANTS_FIELD_ALIASES` に足せばコードを直さず復旧できる。
 */

export const JQUANTS_DEFAULT_BASE_URL = 'https://api.jquants.com/v2';

/**
 * 正準名 → API 側の候補名。**先に書いたものから順に探す。**
 * V2 の短縮名を確定できていない項目があるため、長短どちらも並べてある。
 */
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
  companyName: ['CompanyName', 'CompanyNameJapanese', 'Name', 'CoName', 'Nm', 'CoNm'],
  companyNameEnglish: ['CompanyNameEnglish', 'NameEnglish'],
  sector33: ['Sector33CodeName', 'Sector33Code', 'Sc33Nm'],
  sector17: ['Sector17CodeName', 'Sector17Code', 'Sc17Nm'],
  marketCode: ['MarketCodeName', 'MarketCode', 'MktCdNm'],
  holidayDivision: ['HolidayDivision', 'HolidayDiv', 'HdDiv'],
};

export type JquantsRow = Record<string, unknown>;

export interface JquantsClientOptions {
  readonly baseUrl?: string;
  /** `JQUANTS_FIELD_ALIASES` の中身。正準名 → 追加の候補名。 */
  readonly extraAliases?: Record<string, readonly string[]>;
  readonly fetchImpl?: typeof fetch;
}

export class JquantsError extends Error {
  constructor(
    message: string,
    readonly status?: number,
  ) {
    super(message);
    this.name = 'JquantsError';
  }
}

export class JquantsClient {
  private readonly baseUrl: string;
  private readonly aliases: Record<string, readonly string[]>;
  private readonly doFetch: typeof fetch;

  constructor(
    private readonly apiKey: string,
    options: JquantsClientOptions = {},
  ) {
    if (!apiKey) throw new JquantsError('JQUANTS_API_KEY が未設定');

    // **キーは HTTP ヘッダーに入る。** ASCII 以外が混じっていると
    // fetch が `Cannot convert argument to a ByteString` で落ちる——
    // 何が悪いのか分からないエラーになる。実際、手順書のプレースホルダ
    // （`（同じキー）`）をそのまま貼って、これを踏んだ。
    // ここで止めて、何を直せばいいかを言う。
    if (!/^[\x21-\x7e]+$/.test(apiKey)) {
      throw new JquantsError(
        'JQUANTS_API_KEY に使えない文字が入っている（ASCII の印字可能文字だけ）。' +
          '全角文字・空白・改行が混じっていないか確認すること。' +
          'プレースホルダを貼ったままになっている可能性が高い',
      );
    }
    this.baseUrl = (options.baseUrl ?? JQUANTS_DEFAULT_BASE_URL).replace(/\/+$/, '');
    this.aliases = mergeAliases(FIELD_ALIASES, options.extraAliases ?? {});
    this.doFetch = options.fetchImpl ?? fetch;
  }

  /**
   * ページングを畳んで全件を返す。
   * J-Quants は `pagination_key` を返してくるので、無くなるまで辿る。
   *
   * **レコードは `data` キーに入る。** V1 は経路ごとに違うキー
   * （`info` / `daily_quotes` / …）だったが、V2 は全経路 `data` で揃っている。
   * 既定値にしてあるのは、また変わったときに 1 箇所で受けられるようにするため。
   */
  async getAll(path: string, params: Record<string, string>, key = 'data'): Promise<JquantsRow[]> {
    const rows: JquantsRow[] = [];
    let paginationKey: string | undefined;
    // 無限ループの保険。1 日ぶんが 100 ページを超えることは無い。
    for (let page = 0; page < 100; page += 1) {
      const url = new URL(`${this.baseUrl}${path}`);
      for (const [k, v] of Object.entries(params)) url.searchParams.set(k, v);
      if (paginationKey !== undefined) url.searchParams.set('pagination_key', paginationKey);

      const res = await this.doFetch(url.toString(), {
        headers: { 'x-api-key': this.apiKey, accept: 'application/json' },
      });
      if (!res.ok) {
        const body = await res.text().catch(() => '');
        throw new JquantsError(
          `J-Quants ${path} が ${res.status} を返した: ${body.slice(0, 200)}`,
          res.status,
        );
      }
      const json = (await res.json()) as Record<string, unknown>;
      const chunk = json[key];
      if (Array.isArray(chunk)) rows.push(...(chunk as JquantsRow[]));

      const next = json['pagination_key'];
      if (typeof next !== 'string' || next === '') break;
      paginationKey = next;
    }
    return rows;
  }

  /** 正準名で値を取り出す。見つからなければ `undefined`。 */
  field(row: JquantsRow, canonical: string): unknown {
    const candidates = this.aliases[canonical];
    if (candidates === undefined) return undefined;
    for (const name of candidates) {
      const v = row[name];
      if (v !== undefined && v !== null && v !== '') return v;
    }
    return undefined;
  }

  requireNumber(row: JquantsRow, canonical: string, context: string): number {
    const v = this.field(row, canonical);
    const n = typeof v === 'number' ? v : typeof v === 'string' ? Number(v) : NaN;
    if (!Number.isFinite(n)) {
      throw new JquantsError(
        `項目 "${canonical}" が見つからない（${context}）。` +
          `候補: ${(this.aliases[canonical] ?? []).join(', ')} / 実際のキー: ${Object.keys(row).join(', ')}。` +
          'JQUANTS_FIELD_ALIASES に別名を足すこと。',
      );
    }
    return n;
  }

  optionalNumber(row: JquantsRow, canonical: string): number | null {
    const v = this.field(row, canonical);
    const n = typeof v === 'number' ? v : typeof v === 'string' ? Number(v) : NaN;
    return Number.isFinite(n) ? n : null;
  }

  requireString(row: JquantsRow, canonical: string, context: string): string {
    const v = this.field(row, canonical);
    if (typeof v === 'string' && v !== '') return v;
    if (typeof v === 'number') return String(v);
    throw new JquantsError(
      `項目 "${canonical}" が見つからない（${context}）。` +
        `実際のキー: ${Object.keys(row).join(', ')}。JQUANTS_FIELD_ALIASES に別名を足すこと。`,
    );
  }

  optionalString(row: JquantsRow, canonical: string): string | null {
    const v = this.field(row, canonical);
    if (typeof v === 'string' && v !== '') return v;
    if (typeof v === 'number') return String(v);
    return null;
  }
}

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
 */
export const JP_PATHS = {
  master: '/equities/master',
  dailyBars: '/equities/bars/daily',
  calendar: '/markets/calendar',
} as const;

/** 日本株のデータ取得口。`MarketDataSource` を実装している。 */
export class JquantsJpSource implements MarketDataSource {
  readonly market = 'JP' as const;

  constructor(private readonly client: JquantsClient) {}

  async listSymbols(asOf: string): Promise<SymbolRow[]> {
    // date を指定すると「その日時点の」一覧が返る。廃止銘柄の把握に必須。
    const rows = await this.client.getAll(JP_PATHS.master, { date: asOf });
    return rows.map((row) => {
      const code = this.client.requireString(row, 'code', JP_PATHS.master);
      return {
        symbolId: toSymbolId('JP', code),
        market: 'JP' as const,
        code,
        name: this.client.optionalString(row, 'companyName') ?? code,
        sector33: this.client.optionalString(row, 'sector33'),
        sector17: this.client.optionalString(row, 'sector17'),
        currency: 'JPY',
        listed: true,
      };
    });
  }

  async fetchDailyBars(date: string): Promise<PriceRow[]> {
    // date 指定なら 1 リクエストで全銘柄が返る。
    // 500 銘柄でも 4,000 銘柄でも取得コストが変わらないのはこのため。
    const rows = await this.client.getAll(JP_PATHS.dailyBars, { date });
    const out: PriceRow[] = [];
    for (const row of rows) {
      const code = this.client.requireString(row, 'code', JP_PATHS.dailyBars);
      const close = this.client.optionalNumber(row, 'close');
      // 売買が成立しなかった日は価格が null で返る。その日は行を作らない。
      if (close === null) continue;
      out.push({
        symbolId: toSymbolId('JP', code),
        date: this.client.optionalString(row, 'date') ?? date,
        open: this.client.optionalNumber(row, 'open') ?? close,
        high: this.client.optionalNumber(row, 'high') ?? close,
        low: this.client.optionalNumber(row, 'low') ?? close,
        close,
        volume: this.client.optionalNumber(row, 'volume') ?? 0,
        adjustmentFactor: this.client.optionalNumber(row, 'adjustmentFactor') ?? 1,
        turnover: this.client.optionalNumber(row, 'turnover'),
      });
    }
    return out;
  }

  async tradingCalendar(from: string, to: string): Promise<CalendarRow[]> {
    const rows = await this.client.getAll(JP_PATHS.calendar, { from, to });
    return rows.map((row) => {
      const division = this.client.optionalString(row, 'holidayDivision');
      return {
        market: 'JP' as const,
        date: this.client.requireString(row, 'date', JP_PATHS.calendar),
        // 0 = 非営業日。1 = 営業日、2 = 東証半日立会（営業日として扱う）。
        isOpen: division !== '0',
      };
    });
  }
}

export function createJquantsSource(env: Env): JquantsJpSource {
  const client = new JquantsClient(env.JQUANTS_API_KEY ?? '', {
    baseUrl: env.JQUANTS_BASE_URL || JQUANTS_DEFAULT_BASE_URL,
    extraAliases: parseAliases(env.JQUANTS_FIELD_ALIASES),
  });
  return new JquantsJpSource(client);
}

export function parseAliases(raw: string | undefined): Record<string, readonly string[]> {
  if (!raw || raw.trim() === '') return {};
  try {
    const parsed: unknown = JSON.parse(raw);
    if (typeof parsed !== 'object' || parsed === null) return {};
    const out: Record<string, readonly string[]> = {};
    for (const [k, v] of Object.entries(parsed as Record<string, unknown>)) {
      if (Array.isArray(v)) out[k] = v.filter((x): x is string => typeof x === 'string');
    }
    return out;
  } catch {
    // 設定ミスでパイプライン全体を止めない。既定の別名表で動かす。
    return {};
  }
}

function mergeAliases(
  base: Readonly<Record<string, readonly string[]>>,
  extra: Record<string, readonly string[]>,
): Record<string, readonly string[]> {
  const out: Record<string, readonly string[]> = {};
  for (const [k, v] of Object.entries(base)) out[k] = [...v];
  // 追加ぶんを先頭に置く。運用中に見つけた名前を優先させたいため。
  for (const [k, v] of Object.entries(extra)) out[k] = [...v, ...(out[k] ?? [])];
  return out;
}
