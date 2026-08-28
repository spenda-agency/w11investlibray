/**
 * 銘柄をバッチに割る。
 *
 * Phase 1（500 銘柄）は 1 回の実行で捌けるので、ここは単なる分割で足りる。
 * **Phase 2 で 4,000 銘柄になったときに Queues 化する差し替え点**として先に切ってある。
 */
export function chunk<T>(items: readonly T[], size: number): T[][] {
  if (!Number.isInteger(size) || size < 1) {
    throw new RangeError(`size は 1 以上の整数である必要がある: ${size}`);
  }
  const out: T[][] = [];
  for (let i = 0; i < items.length; i += size) {
    out.push(items.slice(i, i + size));
  }
  return out;
}
