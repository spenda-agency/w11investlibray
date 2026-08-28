import type { NumSeries } from '../types.js';
import { assertPeriod } from './ma.js';

/** `period` 本前からの騰落率。`0.05` なら +5%。 */
export function rateOfChange(values: readonly number[], period: number): NumSeries {
  assertPeriod(period);
  const out: (number | null)[] = new Array(values.length).fill(null);
  for (let i = period; i < values.length; i += 1) {
    const cur = values[i];
    const past = values[i - period];
    if (cur === undefined || past === undefined || past === 0) continue;
    out[i] = cur / past - 1;
  }
  return out;
}

/**
 * 直近 `period` 本の最高値 / 最安値（当日を含む）。
 * 52 週高値には `period = 250`（営業日）を使う。
 *
 * データが `period` 本に満たない期間も、**あるだけで計算して返す**。
 * 上場から日が浅い銘柄を一律に除外すると、新規上場が永久に候補へ出てこなくなる。
 *
 * 単調デックで O(n)。素朴な二重ループだと 5,000 銘柄 × 10 年 × 250 本で
 * バックフィルが目に見えて遅くなる。
 */
export function rollingExtreme(
  values: readonly number[],
  period: number,
  kind: 'high' | 'low',
): NumSeries {
  assertPeriod(period);
  const out: (number | null)[] = new Array(values.length).fill(null);
  const deque: number[] = []; // 候補の index を保持する。先頭が常に区間の最良値
  const isBetter = kind === 'high'
    ? (a: number, b: number) => a >= b
    : (a: number, b: number) => a <= b;

  for (let i = 0; i < values.length; i += 1) {
    const v = values[i];
    if (v === undefined) break;

    // 区間から外れた候補を先頭から捨てる
    const windowStart = i - period + 1;
    while (deque.length > 0 && (deque[0] as number) < windowStart) deque.shift();

    // 新しい値に負ける候補を末尾から捨てる
    while (deque.length > 0) {
      const lastIdx = deque[deque.length - 1] as number;
      const last = values[lastIdx];
      if (last === undefined || isBetter(v, last)) deque.pop();
      else break;
    }
    deque.push(i);

    const bestIdx = deque[0];
    const best = bestIdx === undefined ? undefined : values[bestIdx];
    out[i] = best === undefined ? null : best;
  }
  return out;
}
