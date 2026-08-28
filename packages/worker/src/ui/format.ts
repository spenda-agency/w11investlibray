/** 画面の表示整形。数字は「無い」を 0 と書かない。 */

export function escapeHtml(value: string): string {
  return value
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#39;');
}

export function num(value: number | null, digits = 1): string {
  return value === null || !Number.isFinite(value) ? '—' : value.toFixed(digits);
}

export function price(value: number | null): string {
  if (value === null || !Number.isFinite(value)) return '—';
  return `¥${Math.round(value).toLocaleString('ja-JP')}`;
}

export function pct(value: number | null, digits = 1): string {
  if (value === null || !Number.isFinite(value)) return '—';
  const sign = value > 0 ? '+' : '';
  return `${sign}${(value * 100).toFixed(digits)}%`;
}

export const VERDICT_LABEL: Readonly<Record<string, string>> = {
  BUY_NOW: '条件合致',
  BUY_WATCH: '条件待ち',
  WATCH: '監視',
  AVOID: '見送り',
};

export function verdictLabel(verdict: string): string {
  return VERDICT_LABEL[verdict] ?? verdict;
}

export function verdictClass(verdict: string): string {
  return `v-${verdict.toLowerCase().replace('_', '-')}`;
}
