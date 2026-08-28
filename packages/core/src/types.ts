/**
 * 共通の型。
 *
 * 指標の系列は「入力と同じ長さ」を返し、計算できない先頭区間（ウォームアップ）は
 * `null` を入れる。長さを縮めて返すと、呼び出し側で日付との対応がズレる。
 */

/** 1 本の足。`date` は `YYYY-MM-DD`（市場のローカル日付）。 */
export interface Bar {
  readonly date: string;
  readonly open: number;
  readonly high: number;
  readonly low: number;
  readonly close: number;
  readonly volume: number;
}

/** 欠損を含む数値系列。ウォームアップ区間が `null`。 */
export type NumSeries = readonly (number | null)[];

/** 市場コード。`symbol_id` の名前空間にもなる。 */
export type MarketCode = 'JP' | 'US' | 'FX';

/** 判定の 4 段階。 */
export type Verdict = 'BUY_NOW' | 'BUY_WATCH' | 'WATCH' | 'AVOID';

/** ニュースの重要度。 */
export type Importance = 'S' | 'A' | 'B' | 'C';

/** ある日の 1 銘柄について計算済みの指標一式。 */
export interface IndicatorSnapshot {
  readonly close: number;
  readonly rsi14: number | null;
  readonly macd: number | null;
  readonly macdSignal: number | null;
  readonly macdHist: number | null;
  readonly macdHistPrev: number | null;
  readonly sma5: number | null;
  readonly sma25: number | null;
  readonly sma75: number | null;
  readonly sma200: number | null;
  readonly sma5Prev: number | null;
  readonly sma25Prev: number | null;
  readonly sma75Prev: number | null;
  readonly atr14: number | null;
  readonly volSma20: number | null;
  readonly volRatio: number | null;
  readonly ret20: number | null;
  readonly ret60: number | null;
  readonly hi52: number | null;
  readonly lo52: number | null;
}
