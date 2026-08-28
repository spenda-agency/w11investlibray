import type { NumSeries } from '../types.js';
import { assertPeriod } from './ma.js';

/**
 * RSI（Wilder, 既定 14）。
 *
 * 最初の値は index `period` に出る（`period` 本の変化量が必要なため）。
 * 下落が 1 度も無い区間は 100 を返す（RS が無限大になるケース）。
 */
export function rsi(closes: readonly number[], period = 14): NumSeries {
  assertPeriod(period);
  const out: (number | null)[] = new Array(closes.length).fill(null);
  if (closes.length <= period) return out;

  let gainSum = 0;
  let lossSum = 0;
  for (let i = 1; i <= period; i += 1) {
    const cur = closes[i];
    const prev = closes[i - 1];
    if (cur === undefined || prev === undefined) return out;
    const d = cur - prev;
    if (d >= 0) gainSum += d;
    else lossSum -= d;
  }

  let avgGain = gainSum / period;
  let avgLoss = lossSum / period;
  out[period] = toRsi(avgGain, avgLoss);

  for (let i = period + 1; i < closes.length; i += 1) {
    const cur = closes[i];
    const prev = closes[i - 1];
    if (cur === undefined || prev === undefined) break;
    const d = cur - prev;
    const gain = d > 0 ? d : 0;
    const loss = d < 0 ? -d : 0;
    avgGain = (avgGain * (period - 1) + gain) / period;
    avgLoss = (avgLoss * (period - 1) + loss) / period;
    out[i] = toRsi(avgGain, avgLoss);
  }
  return out;
}

function toRsi(avgGain: number, avgLoss: number): number {
  if (avgLoss === 0) return avgGain === 0 ? 50 : 100;
  const rs = avgGain / avgLoss;
  return 100 - 100 / (1 + rs);
}
