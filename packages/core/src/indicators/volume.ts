import type { NumSeries } from '../types.js';
import { sma } from './ma.js';

/**
 * 出来高の移動平均に対する比。`1.8` なら平常の 1.8 倍。
 * 平均が 0（売買が成立していない日が続いた）のときは `null`。
 */
export function volumeRatio(volumes: readonly number[], period = 20): NumSeries {
  const avg = sma(volumes, period);
  const out: (number | null)[] = new Array(volumes.length).fill(null);
  for (let i = 0; i < volumes.length; i += 1) {
    const v = volumes[i];
    const a = avg[i];
    if (v === undefined || a === null || a === undefined || a === 0) continue;
    out[i] = v / a;
  }
  return out;
}

export { sma as volumeSma } from './ma.js';
