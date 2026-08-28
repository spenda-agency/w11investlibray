/**
 * 日付の扱い。
 *
 * Workers の `Date` は UTC なので、市場のローカル日付は必ず明示的に変換する。
 * ここを暗黙にすると、19:30 JST の Cron が「前日」を処理してしまう。
 */

const MARKET_OFFSET_MINUTES: Readonly<Record<string, number>> = {
  JP: 9 * 60,      // JST
  US: -5 * 60,     // EST（夏時間は Phase 3 で市場カレンダーから引く）
  FX: 0,
};

/** UTC の瞬間を、その市場のローカル日付（YYYY-MM-DD）にする。 */
export function marketDate(now: Date, market: string): string {
  const offset = MARKET_OFFSET_MINUTES[market] ?? 0;
  const shifted = new Date(now.getTime() + offset * 60_000);
  return shifted.toISOString().slice(0, 10);
}

/** `YYYY-MM-DD` から n 日前の日付。 */
export function addDays(date: string, days: number): string {
  const d = new Date(`${date}T00:00:00Z`);
  d.setUTCDate(d.getUTCDate() + days);
  return d.toISOString().slice(0, 10);
}

export function isIsoDate(value: string): boolean {
  if (!/^\d{4}-\d{2}-\d{2}$/.test(value)) return false;
  const d = new Date(`${value}T00:00:00Z`);
  return !Number.isNaN(d.getTime()) && d.toISOString().slice(0, 10) === value;
}
