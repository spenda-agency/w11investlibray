/**
 * インライン SVG のスパークライン。
 *
 * チャートライブラリを読み込んでいないのは、ECharts が約 1MB あり
 * Worker のスクリプトサイズを圧迫するため。本格的なチャートが要るように
 * なったら R2 から配信する（docs/ARCHITECTURE.md）。
 */
export function sparkline(values: readonly number[], width = 160, height = 40): string {
  const clean = values.filter((v) => Number.isFinite(v));
  if (clean.length < 2) return '';

  let min = Infinity;
  let max = -Infinity;
  for (const v of clean) {
    if (v < min) min = v;
    if (v > max) max = v;
  }
  const span = max - min || 1;
  const stepX = width / (clean.length - 1);

  const points = clean.map((v, i) => {
    const x = i * stepX;
    const y = height - ((v - min) / span) * height;
    return `${x.toFixed(1)},${y.toFixed(1)}`;
  });

  const first = clean[0] ?? 0;
  const last = clean[clean.length - 1] ?? 0;
  const trend = last >= first ? 'up' : 'down';

  return `<svg class="spark spark-${trend}" viewBox="0 0 ${width} ${height}" width="${width}" height="${height}" role="img" aria-label="直近の値動き" preserveAspectRatio="none">
    <polyline points="${points.join(' ')}" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linejoin="round" stroke-linecap="round" />
  </svg>`;
}
