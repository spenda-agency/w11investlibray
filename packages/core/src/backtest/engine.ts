import type { Bar, IndicatorSnapshot } from '../types.js';
import { computeSnapshots } from '../indicators/snapshot.js';

/**
 * バックテストエンジン。
 *
 * このファイルの存在理由は速度ではなく **Look-ahead bias を構造で防ぐこと**。
 *
 *   Day t の終値までの情報で判断する
 *        ↓
 *   Day t+1 の「始値」で約定する
 *
 * 「その日の終値を見て、その日の寄り付きで買っていたら」を計算すると
 * 完全にインチキな成績が出る。ここでは以下の 2 つを**実行時に強制**する。
 *
 *   1. ルールに渡す履歴は `t` までしか読めない（`History.at` が例外を投げる）
 *   2. 約定バーは判断バーより後でなければならない（`assertExecutionBar`）
 */

export type ExitReason = 'signal' | 'stop' | 'target' | 'end_of_data';

export interface Trade {
  readonly symbolId: string;
  readonly entryDate: string;
  readonly entryPx: number;
  readonly exitDate: string;
  readonly exitPx: number;
  /** 損益率。`0.082` なら +8.2%。手数料・スリッページ控除後。 */
  readonly pnlPct: number;
  readonly exitReason: ExitReason;
  readonly barsHeld: number;
}

/** ルールが参照できる履歴。**未来を読もうとすると例外になる。** */
export interface History {
  /** 判断してよい最終 index（＝今日）。 */
  readonly cursor: number;
  /** `i <= cursor` の足。範囲外は `RangeError`。 */
  at(i: number): Bar;
  /** `i <= cursor` の指標。範囲外は `RangeError`。 */
  snapshotAt(i: number): IndicatorSnapshot;
}

export interface DecisionContext {
  readonly index: number;
  readonly bar: Bar;
  readonly snapshot: IndicatorSnapshot;
  readonly prevSnapshot: IndicatorSnapshot | null;
  readonly history: History;
}

export interface OpenPosition {
  readonly entryIndex: number;
  readonly entryDate: string;
  readonly entryPx: number;
  readonly stop: number | null;
  readonly target: number | null;
}

export interface Rule {
  readonly id: string;
  /** 買い候補か。`true` なら翌営業日の始値で約定する。 */
  shouldEnter(ctx: DecisionContext): boolean;
  /** 手仕舞いか。`true` なら翌営業日の始値で約定する。 */
  shouldExit(ctx: DecisionContext, position: OpenPosition): boolean;
  /** 約定時の損切り / 利確。`null` なら設定しない。 */
  levels(ctx: DecisionContext): { stop: number | null; target: number | null };
}

export interface BacktestOptions {
  /** 片道の手数料・スリッページ（率）。既定 0.1%。 */
  readonly costPerSide?: number;
  /** 最長保有営業日数。超えたら手仕舞う。既定 60。 */
  readonly maxHoldBars?: number;
}

export interface EquityPoint {
  readonly date: string;
  readonly equity: number;
  /** その日のリターン。ポジションを持っていない日は 0。 */
  readonly ret: number;
}

export interface BacktestResult {
  readonly symbolId: string;
  readonly ruleId: string;
  readonly trades: Trade[];
  readonly equity: EquityPoint[];
}

const DEFAULT_COST_PER_SIDE = 0.001;
const DEFAULT_MAX_HOLD_BARS = 60;

/**
 * 約定バーが判断バーより後であることを確かめる。
 *
 * エンジンが必ず通る道に置いてあるので、同日終値での約定を書こうとすると
 * テストではなく**実行時に**落ちる。
 */
export function assertExecutionBar(decisionIndex: number, executionIndex: number): void {
  if (executionIndex <= decisionIndex) {
    throw new RangeError(
      `同じ足かそれ以前では約定できない（判断 ${decisionIndex} / 約定 ${executionIndex}）。` +
        'Day t の情報で判断し、Day t+1 の始値で約定すること。',
    );
  }
}

function makeHistory(
  bars: readonly Bar[],
  snapshots: readonly IndicatorSnapshot[],
  cursor: number,
): History {
  const guard = (i: number): number => {
    if (!Number.isInteger(i) || i < 0) throw new RangeError(`index が不正: ${i}`);
    if (i > cursor) {
      throw new RangeError(
        `未来を参照しようとした（cursor ${cursor} / 要求 ${i}）。` +
          'その時点で取得できた情報だけで判断すること。',
      );
    }
    return i;
  };
  return {
    cursor,
    at(i) {
      const bar = bars[guard(i)];
      if (bar === undefined) throw new RangeError(`足が無い: ${i}`);
      return bar;
    },
    snapshotAt(i) {
      const s = snapshots[guard(i)];
      if (s === undefined) throw new RangeError(`指標が無い: ${i}`);
      return s;
    },
  };
}

export function runBacktest(
  symbolId: string,
  bars: readonly Bar[],
  rule: Rule,
  options: BacktestOptions = {},
): BacktestResult {
  const cost = options.costPerSide ?? DEFAULT_COST_PER_SIDE;
  const maxHold = options.maxHoldBars ?? DEFAULT_MAX_HOLD_BARS;
  const snapshots = computeSnapshots(bars);

  const trades: Trade[] = [];
  const equity: EquityPoint[] = [];
  let cashEquity = 1;
  let position: OpenPosition | null = null;
  let pendingEntry = false;
  let pendingExit = false;

  for (let t = 0; t < bars.length; t += 1) {
    const bar = bars[t];
    const snap = snapshots[t];
    if (bar === undefined || snap === undefined) break;

    let dayRet = 0;

    // --- ① 前日の判断を、今日の「始値」で約定する ---
    if (pendingEntry && position === null) {
      assertExecutionBar(t - 1, t);
      const prevCtx = contextAt(t - 1);
      const lv = prevCtx === null ? { stop: null, target: null } : rule.levels(prevCtx);
      const fill = bar.open * (1 + cost);
      position = {
        entryIndex: t,
        entryDate: bar.date,
        entryPx: fill,
        stop: lv.stop,
        target: lv.target,
      };
      // 約定日は始値から終値までを取る
      dayRet = bar.close / fill - 1;
      pendingEntry = false;
    } else if (pendingExit && position !== null) {
      assertExecutionBar(t - 1, t);
      const fill = bar.open * (1 - cost);
      dayRet = fill / previousClose(bars, t) - 1;
      trades.push(makeTrade(symbolId, position, bar.date, fill, 'signal', t));
      position = null;
      pendingExit = false;
    } else if (position !== null) {
      // --- ② 保有中。損切り / 利確はザラ場で当たる ---
      const hit = checkStopAndTarget(bar, position);
      if (hit !== null) {
        const fill = hit.price * (1 - cost);
        dayRet = fill / previousClose(bars, t) - 1;
        trades.push(makeTrade(symbolId, position, bar.date, fill, hit.reason, t));
        position = null;
      } else {
        dayRet = bar.close / previousClose(bars, t) - 1;
      }
    }

    // --- ③ 今日の終値までの情報で、明日の行動を決める ---
    if (position !== null) {
      const ctx = contextAt(t);
      const heldTooLong = t - position.entryIndex >= maxHold;
      if (ctx !== null && (heldTooLong || rule.shouldExit(ctx, position))) pendingExit = true;
    } else if (!pendingEntry) {
      const ctx = contextAt(t);
      if (ctx !== null && rule.shouldEnter(ctx)) pendingEntry = true;
    }

    cashEquity *= 1 + dayRet;
    equity.push({ date: bar.date, equity: cashEquity, ret: dayRet });
  }

  // データの終端で持ち越していたら、最終終値で閉じる
  if (position !== null) {
    const last = bars[bars.length - 1];
    if (last !== undefined) {
      trades.push(
        makeTrade(symbolId, position, last.date, last.close * (1 - cost), 'end_of_data', bars.length - 1),
      );
    }
  }

  return { symbolId, ruleId: rule.id, trades, equity };

  function contextAt(i: number): DecisionContext | null {
    const b = bars[i];
    const s = snapshots[i];
    if (b === undefined || s === undefined) return null;
    return {
      index: i,
      bar: b,
      snapshot: s,
      prevSnapshot: i > 0 ? snapshots[i - 1] ?? null : null,
      history: makeHistory(bars, snapshots, i),
    };
  }
}

/**
 * 損切りと利確が同じ足で両方当たったときは、**損切りを優先**する。
 * 日足だけではどちらが先に当たったか分からないので、
 * 成績を良く見せない側に倒す。
 */
function checkStopAndTarget(
  bar: Bar,
  position: OpenPosition,
): { price: number; reason: ExitReason } | null {
  if (position.stop !== null && bar.low <= position.stop) {
    return { price: Math.min(position.stop, bar.open), reason: 'stop' };
  }
  if (position.target !== null && bar.high >= position.target) {
    return { price: Math.max(position.target, bar.open), reason: 'target' };
  }
  return null;
}

function previousClose(bars: readonly Bar[], t: number): number {
  const prev = bars[t - 1];
  const cur = bars[t];
  if (prev !== undefined) return prev.close;
  if (cur !== undefined) return cur.close;
  throw new RangeError(`足が無い: ${t}`);
}

function makeTrade(
  symbolId: string,
  position: OpenPosition,
  exitDate: string,
  exitPx: number,
  exitReason: ExitReason,
  exitIndex: number,
): Trade {
  return {
    symbolId,
    entryDate: position.entryDate,
    entryPx: position.entryPx,
    exitDate,
    exitPx,
    pnlPct: exitPx / position.entryPx - 1,
    exitReason,
    barsHeld: exitIndex - position.entryIndex,
  };
}
