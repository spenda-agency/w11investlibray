import type { IndicatorSnapshot } from '../types.js';

/**
 * ゴールデンクロスの判定。
 *
 * 「5 日線が 25 日線を上抜けた」だけでは弱い。下落トレンドの途中でも起きるし、
 * 出来高を伴わないクロスはすぐ戻る。そこで**条件を重ねて合致数を数える**。
 *
 *   5日線 > 25日線 → 25日線が上向き → 株価 > 25日線 → 株価 > 75日線
 *   → MACD > Signal → Histogram > 0 → RSI 50〜70 → 出来高増加
 *
 * `strength` はこの 8 条件の合致数（0〜8）。
 * `crossedToday` は「今日はじめて 5 日線が 25 日線を上抜けた」かどうか。
 */

export const GOLDEN_CROSS_CONDITIONS = [
  'sma5_above_sma25',
  'sma25_rising',
  'close_above_sma25',
  'close_above_sma75',
  'macd_above_signal',
  'hist_positive',
  'rsi_in_band',
  'volume_expanding',
] as const;

export type GoldenCrossCondition = (typeof GOLDEN_CROSS_CONDITIONS)[number];

export interface GoldenCrossResult {
  /** 合致した条件の数（0〜8）。 */
  readonly strength: number;
  /** 合致した条件の名前。`signals_daily.detail` にそのまま入れる。 */
  readonly met: GoldenCrossCondition[];
  /** 今日はじめて 5 日線が 25 日線を上抜けたか。 */
  readonly crossedToday: boolean;
  /**
   * 「トレンド転換を伴うクロス」と呼べるか。
   * 今日クロスし、かつ 8 条件のうち 6 つ以上が揃っているとき。
   */
  readonly qualified: boolean;
}

/** `qualified` と判定するのに必要な合致数。 */
export const QUALIFIED_STRENGTH = 6;

/** RSI の許容帯。上限を 70 で切るのは、買われすぎからの入りを弾くため。 */
const RSI_BAND: readonly [number, number] = [50, 70];

export function detectGoldenCross(
  today: IndicatorSnapshot,
  yesterday: IndicatorSnapshot | null,
): GoldenCrossResult {
  const met: GoldenCrossCondition[] = [];

  if (gt(today.sma5, today.sma25)) met.push('sma5_above_sma25');
  if (rising(today.sma25, today.sma25Prev)) met.push('sma25_rising');
  if (gt(today.close, today.sma25)) met.push('close_above_sma25');
  if (gt(today.close, today.sma75)) met.push('close_above_sma75');
  if (gt(today.macd, today.macdSignal)) met.push('macd_above_signal');
  if (today.macdHist !== null && today.macdHist > 0) met.push('hist_positive');
  if (today.rsi14 !== null && today.rsi14 >= RSI_BAND[0] && today.rsi14 <= RSI_BAND[1]) {
    met.push('rsi_in_band');
  }
  if (today.volRatio !== null && today.volRatio > 1) met.push('volume_expanding');

  const crossedToday =
    yesterday !== null &&
    gt(today.sma5, today.sma25) &&
    lte(yesterday.sma5, yesterday.sma25);

  return {
    strength: met.length,
    met,
    crossedToday,
    qualified: crossedToday && met.length >= QUALIFIED_STRENGTH,
  };
}

function gt(a: number | null, b: number | null): boolean {
  return a !== null && b !== null && a > b;
}

function lte(a: number | null, b: number | null): boolean {
  return a !== null && b !== null && a <= b;
}

function rising(cur: number | null, prev: number | null): boolean {
  return cur !== null && prev !== null && cur > prev;
}
