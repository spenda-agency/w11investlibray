import { readFile, writeFile, mkdir } from 'node:fs/promises';
import { dirname } from 'node:path';
import {
  applySplitAdjustment,
  goldenCrossRule,
  runBacktest,
  scoreThresholdRule,
  summarise,
  type Bar,
  type PriceRow,
  type Rule,
  type Trade,
} from '@invest/core';
import { insertStatements } from '../sql.js';

/**
 * バックテスト。
 *
 * **本番と同じ `@invest/core` のルールを呼ぶ。** ここで判定を書き直したら、
 * 検証したルールと画面に出るルールが別物になり、この工程の意味が消える。
 *
 * 入力は `{"JP.72030": [{date,open,high,low,close,volume,adjustmentFactor}, ...]}` の JSON。
 * `npm run cli -- export-prices` で D1 から書き出すか、backfill の出力から作る。
 */
export interface BacktestOptions {
  readonly input: string;
  readonly out: string;
  readonly ruleName: string;
  readonly universe: string;
  readonly costPerSide: number;
  readonly maxHoldBars: number;
}

export function resolveRule(name: string): Rule {
  if (name === 'golden-cross') return goldenCrossRule;
  const m = /^score-(\d+)$/.exec(name);
  if (m?.[1] !== undefined) return scoreThresholdRule(Number(m[1]));
  throw new Error(`不明なルール: ${name}（golden-cross / score-NN）`);
}

export async function runBacktestCommand(options: BacktestOptions): Promise<number> {
  const raw = JSON.parse(await readFile(options.input, 'utf8')) as Record<string, PriceRow[]>;
  const rule = resolveRule(options.ruleName);

  const allTrades: Trade[] = [];
  const equityBySymbol: { symbolId: string; equity: { date: string; equity: number; ret: number }[] }[] = [];
  let dateFrom = '9999-12-31';
  let dateTo = '0000-01-01';

  for (const [symbolId, rows] of Object.entries(raw)) {
    if (!Array.isArray(rows) || rows.length < 60) continue;
    // 手で用意した JSON では turnover が欠けていることがある。
    // バックテストは価格しか見ないので、欠けていれば null で補う。
    const sorted = [...rows]
      .map((r) => ({ ...r, turnover: r.turnover ?? null }))
      .sort((a, b) => a.date.localeCompare(b.date));
    // **必ず分割調整してから回す。** 未調整のまま回すと分割日で誤爆する。
    const bars: Bar[] = applySplitAdjustment(sorted);

    const first = bars[0];
    const last = bars[bars.length - 1];
    if (first !== undefined && first.date < dateFrom) dateFrom = first.date;
    if (last !== undefined && last.date > dateTo) dateTo = last.date;

    const result = runBacktest(symbolId, bars, rule, {
      costPerSide: options.costPerSide,
      maxHoldBars: options.maxHoldBars,
    });
    allTrades.push(...result.trades);
    equityBySymbol.push({ symbolId, equity: [...result.equity] });
  }

  // 銘柄ごとのエクイティを日付でならして 1 本にする（等ウェイト）。
  const portfolio = blendEquity(equityBySymbol);
  const stats = summarise(allTrades, portfolio);

  console.error(`ルール         ${rule.id}`);
  console.error(`対象           ${equityBySymbol.length} 銘柄 / ${dateFrom} 〜 ${dateTo}`);
  console.error(`取引           ${stats.trades} 回`);
  console.error(`勝率           ${fmtPct(stats.winRate)}`);
  console.error(`平均利益       ${fmtPct(stats.avgWin)}`);
  console.error(`平均損失       ${fmtPct(stats.avgLoss)}`);
  console.error(`Profit Factor  ${fmt(stats.profitFactor)}`);
  console.error(`期待値         ${fmtPct(stats.expectancy)}`);
  console.error(`最大DD         ${fmtPct(stats.maxDrawdown)}`);
  console.error(`Sharpe         ${fmt(stats.sharpe)}`);
  console.error(`平均保有       ${fmt(stats.avgBarsHeld)} 営業日`);

  const runId = `${rule.id}_${options.universe}_${dateFrom}_${dateTo}`;
  const statements: string[] = [
    '-- 自動生成（npm run backtest）。D1 へ流し込む用。',
    `-- ${runId}`,
    '',
    ...insertStatements(
      'backtest_runs',
      ['run_id', 'rule_id', 'params', 'universe', 'date_from', 'date_to', 'created_at'],
      [[runId, rule.id, JSON.stringify({ costPerSide: options.costPerSide, maxHoldBars: options.maxHoldBars }), options.universe, dateFrom, dateTo, new Date().toISOString()]],
      { conflictTarget: 'run_id' },
    ),
    ...insertStatements(
      'backtest_trades',
      ['run_id', 'symbol_id', 'entry_date', 'entry_px', 'exit_date', 'exit_px', 'pnl_pct', 'exit_reason', 'bars_held'],
      allTrades.map((t) => [runId, t.symbolId, t.entryDate, round(t.entryPx), t.exitDate, round(t.exitPx), round(t.pnlPct, 6), t.exitReason, t.barsHeld]),
      { conflictTarget: 'run_id, symbol_id, entry_date' },
    ),
    ...insertStatements(
      'backtest_stats',
      ['run_id', 'trades', 'win_rate', 'avg_win', 'avg_loss', 'profit_factor', 'expectancy', 'max_drawdown', 'sharpe', 'total_return', 'avg_bars_held'],
      [[runId, stats.trades, round(stats.winRate, 4), round(stats.avgWin, 6), round(stats.avgLoss, 6), finite(stats.profitFactor), round(stats.expectancy, 6), round(stats.maxDrawdown, 6), round(stats.sharpe, 4), round(stats.totalReturn, 6), round(stats.avgBarsHeld, 2)]],
      { conflictTarget: 'run_id' },
    ),
  ];

  await mkdir(dirname(options.out), { recursive: true });
  await writeFile(options.out, statements.join('\n') + '\n', 'utf8');
  console.error(`\n${options.out} に書き出した。`);

  // 取引が少なすぎる結果を「検証済み」と呼ばない。
  if (stats.trades < 30) {
    console.error('\n注意: 取引回数が 30 回未満。統計として結論を出せる量ではない。');
  }
  return 0;
}

/** 銘柄ごとの日次リターンを等ウェイトで合成する。 */
function blendEquity(
  perSymbol: readonly { symbolId: string; equity: { date: string; equity: number; ret: number }[] }[],
): { date: string; equity: number; ret: number }[] {
  const byDate = new Map<string, number[]>();
  for (const s of perSymbol) {
    for (const p of s.equity) {
      const list = byDate.get(p.date) ?? [];
      list.push(p.ret);
      byDate.set(p.date, list);
    }
  }
  const dates = [...byDate.keys()].sort();
  let equity = 1;
  return dates.map((date) => {
    const rets = byDate.get(date) ?? [];
    const mean = rets.length === 0 ? 0 : rets.reduce((a, b) => a + b, 0) / rets.length;
    equity *= 1 + mean;
    return { date, equity, ret: mean };
  });
}

const fmt = (v: number | null): string => (v === null || !Number.isFinite(v) ? '—' : v.toFixed(2));
const fmtPct = (v: number | null): string =>
  v === null || !Number.isFinite(v) ? '—' : `${(v * 100).toFixed(1)}%`;

function round(v: number | null, digits = 2): number | null {
  if (v === null || !Number.isFinite(v)) return null;
  const f = 10 ** digits;
  return Math.round(v * f) / f;
}

function finite(v: number | null): number | null {
  return v === null || !Number.isFinite(v) ? null : Math.round(v * 10000) / 10000;
}
