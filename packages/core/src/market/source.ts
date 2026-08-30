import type { Bar, MarketCode } from '../types.js';

/**
 * 市場ごとのデータ取得口。
 *
 * **Phase 3（米国株）/ Phase 4（FX）でやることは、これを実装して
 * `market_calendar` を埋めるだけ**になるように切ってある。
 * 実装は `packages/worker/src/connectors/` に置く（core は I/O を持たない）。
 */

export interface SymbolRow {
  readonly symbolId: string;
  readonly market: MarketCode;
  readonly code: string;
  readonly name: string;
  readonly sector33: string | null;
  readonly sector17: string | null;
  readonly currency: string;
  /** その日時点で上場しているか。廃止済みなら `false`。 */
  readonly listed: boolean;
}

export interface PriceRow extends Bar {
  readonly symbolId: string;
  /** 分割調整係数。J-Quants の `AdjustmentFactor` をそのまま持つ。 */
  readonly adjustmentFactor: number;
  /**
   * 売買代金。取得できないソースでは `null`。
   *
   * 流動性は「終値 × 出来高」より売買代金のほうが正確（寄り引けや
   * 特別気配で乖離する）。ユニバース選定がこれを見る。
   */
  readonly turnover: number | null;
}

export interface CalendarRow {
  readonly market: MarketCode;
  readonly date: string;
  readonly isOpen: boolean;
}

export interface MarketDataSource {
  readonly market: MarketCode;
  /** `asOf` 時点の銘柄一覧。**廃止銘柄も `listed: false` で返すこと。** */
  listSymbols(asOf: string): Promise<SymbolRow[]>;
  /** その日の全銘柄の足。 */
  fetchDailyBars(date: string): Promise<PriceRow[]>;
  /** 営業日カレンダー。 */
  tradingCalendar(from: string, to: string): Promise<CalendarRow[]>;
}
