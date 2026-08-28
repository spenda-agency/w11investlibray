import {
  applySplitAdjustment,
  computeScore,
  computeSnapshots,
  detectExitSignals,
  detectGoldenCross,
} from '@invest/core';
import type { IndicatorSnapshot } from '@invest/core';
import type { Env } from '../types.js';
import { createJquantsSource } from '../connectors/jquants.js';
import {
  finishJob,
  jobStatus,
  loadRecentBars,
  markDelisted,
  selectRanking,
  selectUniverse,
  startJob,
  upsertCalendar,
  upsertIndicators,
  upsertPrices,
  upsertScores,
  upsertSignals,
  upsertSymbols,
  type IndicatorInsert,
  type ScoreInsert,
  type SignalInsert,
} from '../db/queries.js';
import { addDays, marketDate } from './date.js';

export const JOB_NAME = 'daily_pipeline';

/** SMA200 と 52 週高値のために必要な過去日数。 */
const LOOKBACK_BARS = 300;

export interface PipelineResult {
  readonly date: string;
  readonly skipped: boolean;
  readonly symbols: number;
  readonly prices: number;
  readonly scored: number;
  readonly steps: string[];
}

/**
 * 日次パイプライン。
 *
 * Cron は 1 本だけにして、中の順序はここで直列に持つ。
 * 時刻を 4 本並べるより、`job_runs` で「その日はもう終わっている」を
 * 判定できるほうが再実行に強い。
 *
 *   ① 銘柄一覧と営業日   ② 日足取得   ③ 指標   ④ シグナル
 *   ⑤ スコア            ⑥ R2 へスナップショット
 */
export async function runDailyPipeline(
  env: Env,
  now: Date,
  options: { force?: boolean; date?: string } = {},
): Promise<PipelineResult> {
  const market = (env.MARKETS || 'JP').split(',')[0]?.trim() || 'JP';
  const targetDate = options.date ?? marketDate(now, market);
  const steps: string[] = [];

  const existing = await jobStatus(env.INVEST_DB, JOB_NAME, targetDate);
  if (existing === 'ok' && options.force !== true) {
    return { date: targetDate, skipped: true, symbols: 0, prices: 0, scored: 0, steps: ['skipped'] };
  }

  const startedAt = now.toISOString();
  await startJob(env.INVEST_DB, JOB_NAME, targetDate, startedAt);

  try {
    const source = createJquantsSource(env);

    // ① 銘柄一覧と営業日カレンダー
    const symbols = await source.listSymbols(targetDate);
    if (symbols.length > 0) {
      await upsertSymbols(env.INVEST_DB, symbols, startedAt);
      await markDelisted(env.INVEST_DB, market, symbols.map((s) => s.symbolId), targetDate);
    }
    const calendar = await source.tradingCalendar(addDays(targetDate, -7), addDays(targetDate, 7));
    await upsertCalendar(env.INVEST_DB, calendar);
    steps.push(`symbols=${symbols.length}`);

    // 非営業日なら、ここで終える。休場日に前日のスコアを上書きしない。
    const today = calendar.find((c) => c.date === targetDate);
    if (today !== undefined && !today.isOpen) {
      await finishJob(env.INVEST_DB, JOB_NAME, targetDate, new Date().toISOString(), 0, null);
      return { date: targetDate, skipped: true, symbols: symbols.length, prices: 0, scored: 0, steps: [...steps, 'market_closed'] };
    }

    // ② 日足（date 指定なら 1 リクエストで全銘柄が返る）
    const bars = await source.fetchDailyBars(targetDate);
    await upsertPrices(env.INVEST_DB, bars);
    steps.push(`prices=${bars.length}`);

    // ③〜⑤ ユニバースを絞って指標・シグナル・スコア
    const limit = Number(env.UNIVERSE_LIMIT) || 500;
    const universe = await selectUniverse(env.INVEST_DB, market, targetDate, limit);
    steps.push(`universe=${universe.length}`);

    const scored = await scoreUniverse(env, universe, targetDate);
    steps.push(`scored=${scored}`);

    // ⑥ スナップショット
    await writeSnapshot(env, targetDate);
    steps.push('snapshot');

    await finishJob(env.INVEST_DB, JOB_NAME, targetDate, new Date().toISOString(), scored, null);
    return { date: targetDate, skipped: false, symbols: symbols.length, prices: bars.length, scored, steps };
  } catch (err) {
    const message = err instanceof Error ? `${err.name}: ${err.message}` : String(err);
    await finishJob(env.INVEST_DB, JOB_NAME, targetDate, new Date().toISOString(), 0, message);
    throw err;
  }
}

/**
 * ユニバースの各銘柄について指標・シグナル・スコアを計算して保存する。
 *
 * 銘柄をまとめて読み、まとめて書く。Phase 1（500 銘柄）は 1 回で捌けるので
 * Queues を挟んでいない。**Phase 2 で 4,000 銘柄になったらここを Queues 化する。**
 */
async function scoreUniverse(env: Env, universe: readonly string[], targetDate: string): Promise<number> {
  if (universe.length === 0) return 0;

  const indicatorRows: IndicatorInsert[] = [];
  const signalRows: SignalInsert[] = [];
  const scoreRows: ScoreInsert[] = [];

  const BATCH = 100;
  for (let i = 0; i < universe.length; i += BATCH) {
    const group = universe.slice(i, i + BATCH);
    const barsBySymbol = await loadRecentBars(env.INVEST_DB, group, targetDate, LOOKBACK_BARS);

    for (const symbolId of group) {
      const raw = barsBySymbol.get(symbolId);
      // 指標が意味を持つ最低本数。これ未満は候補に出さない。
      if (raw === undefined || raw.length < 30) continue;

      // **分割調整してから指標を計算する。**
      // ここを飛ばすと、分割日をまたいだ瞬間に移動平均が一斉に誤爆する。
      const adjusted = applySplitAdjustment(raw);
      const snapshots = computeSnapshots(adjusted);

      const last = snapshots[snapshots.length - 1];
      const prev = snapshots.length >= 2 ? snapshots[snapshots.length - 2] ?? null : null;
      const lastBar = adjusted[adjusted.length - 1];
      if (last === undefined || lastBar === undefined) continue;
      // 当日の足が無い銘柄（売買不成立・上場前）は当日ぶんを書かない。
      if (lastBar.date !== targetDate) continue;

      indicatorRows.push(toIndicatorRow(symbolId, targetDate, last));

      const gc = detectGoldenCross(last, prev);
      signalRows.push({
        symbolId,
        date: targetDate,
        signalCode: 'golden_cross',
        strength: gc.strength,
        detail: JSON.stringify({ met: gc.met, crossedToday: gc.crossedToday, qualified: gc.qualified }),
      });

      const exit = detectExitSignals(last, prev);
      signalRows.push({
        symbolId,
        date: targetDate,
        signalCode: 'exit',
        strength: exit.met.length,
        detail: JSON.stringify({ met: exit.met }),
      });

      const score = computeScore(last);
      scoreRows.push({
        symbolId,
        date: targetDate,
        scoreVersion: score.scoreVersion,
        total: score.total,
        cTrend: score.components.trend,
        cRsi: score.components.rsi,
        cMacd: score.components.macd,
        cMa: score.components.ma,
        cVolume: score.components.volume,
        cMomentum: score.components.momentum,
        cFundamental: score.components.fundamental,
        cNews: score.components.news,
        verdict: score.verdict,
        entryPx: score.levels.entry,
        stopPx: score.levels.stop,
        targetPx: score.levels.target,
        rr: score.levels.rr,
      });
    }
  }

  await upsertIndicators(env.INVEST_DB, indicatorRows);
  await upsertSignals(env.INVEST_DB, signalRows);
  await upsertScores(env.INVEST_DB, scoreRows);
  return scoreRows.length;
}

function toIndicatorRow(symbolId: string, date: string, s: IndicatorSnapshot): IndicatorInsert {
  return {
    symbolId,
    date,
    rsi14: s.rsi14,
    macd: s.macd,
    macdSignal: s.macdSignal,
    macdHist: s.macdHist,
    sma5: s.sma5,
    sma25: s.sma25,
    sma75: s.sma75,
    sma200: s.sma200,
    atr14: s.atr14,
    volSma20: s.volSma20,
    volRatio: s.volRatio,
    ret20: s.ret20,
    ret60: s.ret60,
    hi52: s.hi52,
    lo52: s.lo52,
  };
}

/**
 * その日のランキングを R2 に置く。
 *
 * 画面はまずここを読むので、D1 が重いときでもトップページが返る。
 * Phase 6 の RAG もここを入力にする。
 */
async function writeSnapshot(env: Env, date: string): Promise<void> {
  const ranking = await selectRanking(env.INVEST_DB, date, { limit: 200 });
  const body = JSON.stringify({ date, generatedAt: new Date().toISOString(), ranking }, null, 2);
  await env.INVEST_R2.put(`snapshots/${date}.json`, body, {
    httpMetadata: { contentType: 'application/json; charset=utf-8' },
  });
  await env.INVEST_R2.put('snapshots/latest.json', body, {
    httpMetadata: { contentType: 'application/json; charset=utf-8' },
  });
}
