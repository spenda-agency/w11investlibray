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

/**
 * Cron の発火時刻から、パイプラインが狙うべき日付を決める。
 *
 * **朝の回収run は「前日」を狙う。** 07:00 JST に走るのは前夜 19:30 の
 * 取りこぼしを拾うためで、当日はまだ場が開いていない（09:00 JST）。
 * `marketDate` はトリガー時刻の JST 日付を返すので、そのまま使うと
 * **まだ存在しない日のデータを取りに行ってしまう。**
 *
 *   10:30 UTC 月 → 19:30 JST 月 → 月（本走。当日）
 *   22:00 UTC 月 → 07:00 JST 火 → 月（回収。前日）
 *
 * 境界は JST の正午。本走は 19:30、回収は 07:00 なので、
 * どちらに寄っても取り違えない。
 */
export function scheduledTargetDate(now: Date, market: string): string {
  const today = marketDate(now, market);
  const offset = MARKET_OFFSET_MINUTES[market] ?? 0;
  const localHour = new Date(now.getTime() + offset * 60_000).getUTCHours();
  return localHour < 12 ? addDays(today, -1) : today;
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
