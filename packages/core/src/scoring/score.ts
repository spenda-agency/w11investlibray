import type { IndicatorSnapshot, Verdict } from '../types.js';

/**
 * スコアリング。**`docs/SCORING.md` と 1 対 1 で対応する。**
 * 配点を変えるときは、先にあのファイルを直し、`scoreVersion` を上げること。
 */

export const SCORE_VERSION_TECHNICAL = 'v1-technical';
export const SCORE_VERSION_FULL = 'v2-full';

/** 各項目の満点。合計 100。 */
export const COMPONENT_MAX = {
  trend: 20,
  rsi: 10,
  macd: 15,
  ma: 15,
  volume: 10,
  momentum: 10,
  fundamental: 10,
  news: 10,
} as const;

export type ComponentName = keyof typeof COMPONENT_MAX;

export interface ScoreComponents {
  readonly trend: number | null;
  readonly rsi: number | null;
  readonly macd: number | null;
  readonly ma: number | null;
  readonly volume: number | null;
  readonly momentum: number | null;
  readonly fundamental: number | null;
  readonly news: number | null;
}

export interface TradeLevels {
  readonly entry: number;
  readonly stop: number | null;
  readonly target: number | null;
  /** リスクリワード比。損切り幅に対する利確幅。 */
  readonly rr: number | null;
}

export interface ScoreResult {
  readonly scoreVersion: string;
  /** 0〜100。埋まっている項目だけで正規化した値。全項目が `null` なら `null`。 */
  readonly total: number | null;
  readonly components: ScoreComponents;
  readonly verdict: Verdict;
  readonly levels: TradeLevels;
}

export interface ScoreInput {
  /** Phase 1b で埋める。0〜10。 */
  readonly fundamental?: number | null;
  /** Phase 1b で埋める。0〜10。 */
  readonly news?: number | null;
}

/** ATR に対する損切り幅の倍率。 */
const STOP_ATR_MULT = 2.0;
/** ATR に対する利確幅の倍率。 */
const TARGET_ATR_MULT = 3.0;
/** これを下回るリスクリワード比では `BUY_NOW` にしない。 */
const MIN_RR_FOR_BUY_NOW = 1.2;

export function computeScore(s: IndicatorSnapshot, input: ScoreInput = {}): ScoreResult {
  const components: ScoreComponents = {
    trend: scoreTrend(s),
    rsi: scoreRsi(s),
    macd: scoreMacd(s),
    ma: scoreMa(s),
    volume: scoreVolume(s),
    momentum: scoreMomentum(s),
    fundamental: input.fundamental ?? null,
    news: input.news ?? null,
  };

  const total = normalise(components);
  const levels = computeLevels(s);
  const verdict = decideVerdict(s, components, total, levels);
  const scoreVersion =
    components.fundamental === null || components.news === null
      ? SCORE_VERSION_TECHNICAL
      : SCORE_VERSION_FULL;

  return { scoreVersion, total, components, verdict, levels };
}

/**
 * 埋まっている項目だけで 0〜100 に正規化する。
 *
 * **欠損項目を 0 点として扱わない。** 0 点にすると「ニュースが無い銘柄」が
 * 「悪材料のある銘柄」と同じ扱いになってしまう。
 */
export function normalise(components: ScoreComponents): number | null {
  let earned = 0;
  let possible = 0;
  for (const name of Object.keys(COMPONENT_MAX) as ComponentName[]) {
    const value = components[name];
    if (value === null) continue;
    earned += value;
    possible += COMPONENT_MAX[name];
  }
  if (possible === 0) return null;
  return Math.round((earned / possible) * 100);
}

function scoreTrend(s: IndicatorSnapshot): number | null {
  if (s.sma25 === null || s.sma75 === null || s.sma25Prev === null || s.sma75Prev === null) {
    return null;
  }
  let p = 0;
  if (s.close > s.sma25) p += 5;
  if (s.close > s.sma75) p += 5;
  if (s.sma25 > s.sma25Prev) p += 5;
  if (s.sma75 > s.sma75Prev) p += 5;
  return p;
}

function scoreRsi(s: IndicatorSnapshot): number | null {
  const r = s.rsi14;
  if (r === null) return null;
  if (r >= 80) return 1;
  if (r >= 70) return 4;
  if (r >= 65) return 8;
  if (r >= 50) return 10;
  if (r >= 45) return 7;
  if (r >= 40) return 5;
  if (r >= 30) return 3;
  return 2;
}

function scoreMacd(s: IndicatorSnapshot): number | null {
  if (s.macd === null || s.macdSignal === null || s.macdHist === null) return null;
  let p = 0;
  if (s.macd > s.macdSignal) p += 6;
  if (s.macdHist > 0) p += 4;
  if (s.macdHistPrev !== null && s.macdHist > s.macdHistPrev) p += 3;
  if (s.macd > 0) p += 2;
  return p;
}

function scoreMa(s: IndicatorSnapshot): number | null {
  if (s.sma5 === null || s.sma25 === null || s.sma75 === null || s.sma200 === null) return null;
  let p = 0;
  if (s.sma5 > s.sma25) p += 5;
  if (s.sma25 > s.sma75) p += 5;
  if (s.close > s.sma200) p += 3;
  if (s.sma5Prev !== null && s.sma5 > s.sma5Prev) p += 2;
  return p;
}

function scoreVolume(s: IndicatorSnapshot): number | null {
  const v = s.volRatio;
  if (v === null) return null;
  // 3 倍超を満点にしない。急騰でも急落でも起きるので、単独では強気の材料にならない。
  if (v >= 3.0) return 6;
  if (v >= 1.5) return 10;
  if (v >= 1.2) return 8;
  if (v >= 0.8) return 4;
  return 1;
}

function scoreMomentum(s: IndicatorSnapshot): number | null {
  if (s.ret20 === null || s.ret60 === null || s.hi52 === null) return null;
  let p = 0;
  if (s.ret20 > 0) p += 3;
  if (s.ret60 > 0) p += 3;
  if (s.hi52 > 0 && s.close >= s.hi52 * 0.9) p += 4;
  return p;
}

/**
 * エントリー / 損切り / 利確。**予測はせず ATR から機械的に決める。**
 *
 * 損切りは終値 - 2ATR を基本とするが、それが 25 日線より下になる場合は
 * 25 日線のわずか下を使う。25 日線割れは多くの参加者が見ている水準なので、
 * そこを割ってなお ATR 幅ぶん耐える理由が無い。
 */
export function computeLevels(s: IndicatorSnapshot): TradeLevels {
  const entry = s.close;
  if (s.atr14 === null || s.atr14 <= 0) {
    return { entry, stop: null, target: null, rr: null };
  }

  let stop = entry - STOP_ATR_MULT * s.atr14;
  if (s.sma25 !== null && s.sma25 < entry && stop < s.sma25) {
    stop = s.sma25 * 0.99;
  }
  const target = entry + TARGET_ATR_MULT * s.atr14;

  const risk = entry - stop;
  const rr = risk > 0 ? (target - entry) / risk : null;
  return { entry, stop, target, rr };
}

function decideVerdict(
  s: IndicatorSnapshot,
  c: ScoreComponents,
  total: number | null,
  levels: TradeLevels,
): Verdict {
  // 下降トレンドは総合点に関わらず避ける。
  const downtrend =
    s.sma75 !== null &&
    s.close < s.sma75 &&
    s.sma25 !== null &&
    s.sma25Prev !== null &&
    s.sma25 < s.sma25Prev;
  if (downtrend) return 'AVOID';
  if (total === null) return 'WATCH';

  const buyNow =
    total >= 75 &&
    c.macd !== null &&
    c.macd >= 10 &&
    s.rsi14 !== null &&
    s.rsi14 < 70 &&
    s.volRatio !== null &&
    s.volRatio >= 1.0 &&
    levels.rr !== null &&
    levels.rr >= MIN_RR_FOR_BUY_NOW;
  if (buyNow) return 'BUY_NOW';

  if (total >= 60) return 'BUY_WATCH';
  if (total >= 40) return 'WATCH';
  return 'AVOID';
}
