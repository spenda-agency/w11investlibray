import type { NumSeries } from '../types.js';
import { ema } from './ma.js';

export interface MacdResult {
  readonly macd: NumSeries;
  readonly signal: NumSeries;
  readonly histogram: NumSeries;
}

/**
 * MACD（既定 12 / 26 / 9）。
 *
 * シグナル線は「MACD 系列が始まる位置」から数え始める。
 * MACD が `null` の区間を 0 として EMA に流し込むと、シグナル線が
 * 序盤にゼロへ引っ張られて偽のクロスが出る。
 */
export function macd(
  closes: readonly number[],
  fastPeriod = 12,
  slowPeriod = 26,
  signalPeriod = 9,
): MacdResult {
  if (fastPeriod >= slowPeriod) {
    throw new RangeError(`fastPeriod は slowPeriod より短い必要がある: ${fastPeriod} >= ${slowPeriod}`);
  }
  const fast = ema(closes, fastPeriod);
  const slow = ema(closes, slowPeriod);

  const line: (number | null)[] = new Array(closes.length).fill(null);
  for (let i = 0; i < closes.length; i += 1) {
    const f = fast[i];
    const s = slow[i];
    line[i] = f === null || f === undefined || s === null || s === undefined ? null : f - s;
  }

  const macdStart = slowPeriod - 1;
  const signal = ema(line, signalPeriod, macdStart);

  const histogram: (number | null)[] = new Array(closes.length).fill(null);
  for (let i = 0; i < closes.length; i += 1) {
    const m = line[i];
    const g = signal[i];
    histogram[i] = m === null || m === undefined || g === null || g === undefined ? null : m - g;
  }

  return { macd: line, signal, histogram };
}
