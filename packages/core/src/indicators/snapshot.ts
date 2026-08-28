import type { Bar, IndicatorSnapshot } from '../types.js';
import { sma } from './ma.js';
import { rsi } from './rsi.js';
import { macd } from './macd.js';
import { atr } from './atr.js';
import { volumeRatio } from './volume.js';
import { rateOfChange, rollingExtreme } from './momentum.js';

/** 52 週 ≒ 250 営業日。 */
export const WEEKS52_BARS = 250;

/**
 * 足の系列から、日ごとの指標一式を計算する。
 *
 * 入力と同じ長さの配列を返す。**入力の並び順は日付の昇順である前提**で、
 * 呼び出し側がそれを保証する（ここでソートすると、渡された順序に
 * 意味があるケースを黙って壊す）。
 *
 * 前日値（`*Prev`）を snapshot に含めているのは、スコアリングが
 * 「25 日線が上向き」「ヒストグラムが拡大」のような**変化**を見るため。
 * スコアリング側に系列を渡すと、そこで添字を扱うことになり
 * off-by-one が入り込む余地が増える。
 */
export function computeSnapshots(bars: readonly Bar[]): IndicatorSnapshot[] {
  const closes = bars.map((b) => b.close);
  const volumes = bars.map((b) => b.volume);

  const rsi14 = rsi(closes, 14);
  const m = macd(closes, 12, 26, 9);
  const sma5 = sma(closes, 5);
  const sma25 = sma(closes, 25);
  const sma75 = sma(closes, 75);
  const sma200 = sma(closes, 200);
  const atr14 = atr(bars, 14);
  const volSma20 = sma(volumes, 20);
  const volRatio = volumeRatio(volumes, 20);
  const ret20 = rateOfChange(closes, 20);
  const ret60 = rateOfChange(closes, 60);
  const hi52 = rollingExtreme(closes, WEEKS52_BARS, 'high');
  const lo52 = rollingExtreme(closes, WEEKS52_BARS, 'low');

  const out: IndicatorSnapshot[] = [];
  for (let i = 0; i < bars.length; i += 1) {
    const bar = bars[i];
    if (bar === undefined) break;
    out.push({
      close: bar.close,
      rsi14: pick(rsi14, i),
      macd: pick(m.macd, i),
      macdSignal: pick(m.signal, i),
      macdHist: pick(m.histogram, i),
      macdHistPrev: pick(m.histogram, i - 1),
      sma5: pick(sma5, i),
      sma25: pick(sma25, i),
      sma75: pick(sma75, i),
      sma200: pick(sma200, i),
      sma5Prev: pick(sma5, i - 1),
      sma25Prev: pick(sma25, i - 1),
      sma75Prev: pick(sma75, i - 1),
      atr14: pick(atr14, i),
      volSma20: pick(volSma20, i),
      volRatio: pick(volRatio, i),
      ret20: pick(ret20, i),
      ret60: pick(ret60, i),
      hi52: pick(hi52, i),
      lo52: pick(lo52, i),
    });
  }
  return out;
}

function pick(series: readonly (number | null)[], i: number): number | null {
  if (i < 0) return null;
  const v = series[i];
  return v === undefined ? null : v;
}
