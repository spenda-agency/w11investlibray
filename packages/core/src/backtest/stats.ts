import type { EquityPoint, Trade } from './engine.js';

/** 1 年の営業日数。Sharpe の年率換算に使う。 */
export const TRADING_DAYS_PER_YEAR = 250;

export interface BacktestStats {
  readonly trades: number;
  /** 勝率。`0.57` なら 57%。 */
  readonly winRate: number | null;
  readonly avgWin: number | null;
  readonly avgLoss: number | null;
  /** 総利益 ÷ 総損失。1 を超えれば期待値がプラス。 */
  readonly profitFactor: number | null;
  /** 1 トレードあたりの期待損益率。 */
  readonly expectancy: number | null;
  /** 最大ドローダウン。`-0.18` なら -18%。 */
  readonly maxDrawdown: number | null;
  /** 日次リターンから年率換算した Sharpe。 */
  readonly sharpe: number | null;
  readonly totalReturn: number | null;
  readonly avgBarsHeld: number | null;
}

export function summarise(trades: readonly Trade[], equity: readonly EquityPoint[]): BacktestStats {
  const wins = trades.filter((t) => t.pnlPct > 0);
  const losses = trades.filter((t) => t.pnlPct <= 0);

  const grossProfit = wins.reduce((a, t) => a + t.pnlPct, 0);
  const grossLoss = losses.reduce((a, t) => a - t.pnlPct, 0);

  return {
    trades: trades.length,
    winRate: trades.length === 0 ? null : wins.length / trades.length,
    avgWin: wins.length === 0 ? null : grossProfit / wins.length,
    avgLoss: losses.length === 0 ? null : -grossLoss / losses.length,
    profitFactor: grossLoss === 0 ? (grossProfit > 0 ? Infinity : null) : grossProfit / grossLoss,
    expectancy:
      trades.length === 0 ? null : trades.reduce((a, t) => a + t.pnlPct, 0) / trades.length,
    maxDrawdown: maxDrawdown(equity),
    sharpe: sharpe(equity),
    totalReturn: totalReturn(equity),
    avgBarsHeld:
      trades.length === 0 ? null : trades.reduce((a, t) => a + t.barsHeld, 0) / trades.length,
  };
}

export function maxDrawdown(equity: readonly EquityPoint[]): number | null {
  if (equity.length === 0) return null;
  let peak = -Infinity;
  let worst = 0;
  for (const point of equity) {
    if (point.equity > peak) peak = point.equity;
    if (peak > 0) {
      const dd = point.equity / peak - 1;
      if (dd < worst) worst = dd;
    }
  }
  return worst;
}

/**
 * 日次リターンから年率換算した Sharpe（無リスク金利 0 とする）。
 *
 * トレード単位ではなく日次で計算するのは、保有期間の長短で
 * 値がぶれないようにするため。標本標準偏差（n-1）を使う。
 */
export function sharpe(equity: readonly EquityPoint[]): number | null {
  const rets = equity.map((p) => p.ret);
  if (rets.length < 2) return null;
  const mean = rets.reduce((a, r) => a + r, 0) / rets.length;
  const variance = rets.reduce((a, r) => a + (r - mean) ** 2, 0) / (rets.length - 1);
  const sd = Math.sqrt(variance);
  if (sd === 0) return null;
  return (mean / sd) * Math.sqrt(TRADING_DAYS_PER_YEAR);
}

export function totalReturn(equity: readonly EquityPoint[]): number | null {
  const last = equity[equity.length - 1];
  return last === undefined ? null : last.equity - 1;
}
