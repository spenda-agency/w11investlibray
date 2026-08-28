import type { IndicatorSnapshot } from '../types.js';

/**
 * 手仕舞い側のシグナル。
 *
 * 「買い」だけを出して「いつ降りるか」を出さないと、判断支援として成立しない。
 * バックテストの EXIT 条件もこれを使う。
 */
export const EXIT_CONDITIONS = [
  'rsi_overbought',
  'macd_dead_cross',
  'below_sma25',
  'sma25_falling',
] as const;

export type ExitCondition = (typeof EXIT_CONDITIONS)[number];

export interface ExitSignalResult {
  readonly met: ExitCondition[];
  /** 1 つでも当たれば手仕舞い検討。 */
  readonly triggered: boolean;
}

/** RSI がこの値を超えたら買われすぎとみなす。 */
const RSI_OVERBOUGHT = 75;

export function detectExitSignals(
  today: IndicatorSnapshot,
  yesterday: IndicatorSnapshot | null,
): ExitSignalResult {
  const met: ExitCondition[] = [];

  if (today.rsi14 !== null && today.rsi14 > RSI_OVERBOUGHT) met.push('rsi_overbought');

  const deadCross =
    yesterday !== null &&
    today.macd !== null &&
    today.macdSignal !== null &&
    yesterday.macd !== null &&
    yesterday.macdSignal !== null &&
    today.macd < today.macdSignal &&
    yesterday.macd >= yesterday.macdSignal;
  if (deadCross) met.push('macd_dead_cross');

  if (today.sma25 !== null && today.close < today.sma25) met.push('below_sma25');
  if (today.sma25 !== null && today.sma25Prev !== null && today.sma25 < today.sma25Prev) {
    met.push('sma25_falling');
  }

  return { met, triggered: met.length > 0 };
}
