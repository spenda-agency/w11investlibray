import type { NumSeries } from '../types.js';

/**
 * 単純移動平均。`period` 本たまるまでは `null`。
 *
 * 差分更新（足して引く）にしているのは、5,000 銘柄 × 10 年を回すため。
 * 浮動小数の誤差が蓄積しないよう、`period` ごとに合計を組み直す。
 */
export function sma(values: readonly number[], period: number): NumSeries {
  assertPeriod(period);
  const out: (number | null)[] = new Array(values.length).fill(null);
  if (values.length < period) return out;

  let sum = 0;
  for (let i = 0; i < values.length; i += 1) {
    const v = values[i];
    if (v === undefined) break;
    sum += v;
    if (i >= period) {
      const drop = values[i - period];
      if (drop === undefined) break;
      sum -= drop;
    }
    if (i >= period - 1) {
      // 一定間隔で合計を組み直し、差分更新の誤差蓄積を断ち切る。
      if ((i - period + 1) % 1024 === 0) sum = exactSum(values, i - period + 1, i);
      out[i] = sum / period;
    }
  }
  return out;
}

/**
 * 指数移動平均。先頭 `period` 本の単純平均で初期化する（Wilder ではなく一般的な EMA）。
 *
 * `offset` を指定すると、それより前を無視して `offset` から数え始める。
 * MACD のシグナル線（MACD 系列自体が途中から始まる）で使う。
 */
export function ema(values: NumSeries, period: number, offset = 0): NumSeries {
  assertPeriod(period);
  const out: (number | null)[] = new Array(values.length).fill(null);
  const first = offset + period - 1;
  if (first >= values.length) return out;

  let seed = 0;
  for (let i = offset; i <= first; i += 1) {
    const v = values[i];
    if (v === null || v === undefined) return out; // 種の区間に欠損があれば計算しない
    seed += v;
  }
  let prev = seed / period;
  out[first] = prev;

  const k = 2 / (period + 1);
  for (let i = first + 1; i < values.length; i += 1) {
    const v = values[i];
    if (v === null || v === undefined) {
      out[i] = null;
      continue;
    }
    prev = v * k + prev * (1 - k);
    out[i] = prev;
  }
  return out;
}

/**
 * Wilder の平滑化。RSI と ATR が使う。
 * 先頭 `period` 本の単純平均で初期化し、以後 `(prev*(n-1) + v) / n`。
 */
export function wilderSmooth(values: readonly number[], period: number): NumSeries {
  assertPeriod(period);
  const out: (number | null)[] = new Array(values.length).fill(null);
  if (values.length < period) return out;

  let seed = 0;
  for (let i = 0; i < period; i += 1) {
    const v = values[i];
    if (v === undefined) return out;
    seed += v;
  }
  let prev = seed / period;
  out[period - 1] = prev;

  for (let i = period; i < values.length; i += 1) {
    const v = values[i];
    if (v === undefined) break;
    prev = (prev * (period - 1) + v) / period;
    out[i] = prev;
  }
  return out;
}

function exactSum(values: readonly number[], from: number, to: number): number {
  let s = 0;
  for (let i = from; i <= to; i += 1) {
    const v = values[i];
    if (v === undefined) break;
    s += v;
  }
  return s;
}

export function assertPeriod(period: number): void {
  if (!Number.isInteger(period) || period < 1) {
    throw new RangeError(`period は 1 以上の整数である必要がある: ${period}`);
  }
}
