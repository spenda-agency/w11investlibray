import type { Bar, NumSeries } from '../types.js';
import { assertPeriod, wilderSmooth } from './ma.js';

/**
 * True Range。index 0 は前日終値が無いので `high - low` を使う。
 */
export function trueRange(bars: readonly Bar[]): number[] {
  const out: number[] = new Array(bars.length).fill(0);
  for (let i = 0; i < bars.length; i += 1) {
    const b = bars[i];
    if (b === undefined) break;
    if (i === 0) {
      out[i] = b.high - b.low;
      continue;
    }
    const prev = bars[i - 1];
    if (prev === undefined) break;
    out[i] = Math.max(b.high - b.low, Math.abs(b.high - prev.close), Math.abs(b.low - prev.close));
  }
  return out;
}

/**
 * ATR（Wilder, 既定 14）。
 *
 * 損切り幅をパーセントではなく ATR で決めるために使う。
 * 値幅の大きい銘柄と小さい銘柄に同じ「-7%」を当てても意味が違う。
 */
export function atr(bars: readonly Bar[], period = 14): NumSeries {
  assertPeriod(period);
  return wilderSmooth(trueRange(bars), period);
}
