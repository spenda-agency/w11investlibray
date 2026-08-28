import { QUALIFIED_STRENGTH } from '@invest/core';
import type { Env } from '../types.js';
import {
  countQualifiedGoldenCross,
  countVerdicts,
  lastSuccessfulJob,
  latestScoredDate,
  selectRanking,
  selectSymbolDetail,
} from '../db/queries.js';
import { JOB_NAME, runDailyPipeline } from '../jobs/dailyPipeline.js';
import { isIsoDate, marketDate } from '../jobs/date.js';

export function json(data: unknown, status = 200): Response {
  return new Response(JSON.stringify(data, null, 2), {
    status,
    headers: {
      'content-type': 'application/json; charset=utf-8',
      'cache-control': 'no-store',
    },
  });
}

/**
 * 監視用。**ここだけ認証を外す**ので、内部の数字は出さない。
 * 最後にパイプラインが成功した日付と、それが今日から何日前かだけ返す。
 */
export async function handleHealth(env: Env): Promise<Response> {
  const last = await lastSuccessfulJob(env.INVEST_DB, JOB_NAME);
  const today = marketDate(new Date(), (env.MARKETS || 'JP').split(',')[0] ?? 'JP');
  const lagDays =
    last === null
      ? null
      : Math.round(
          (Date.parse(`${today}T00:00:00Z`) - Date.parse(`${last.target_date}T00:00:00Z`)) / 86_400_000,
        );
  // 4 日以上更新が無ければ異常。連休を挟んでも 3 日で復帰するはず。
  const healthy = lagDays !== null && lagDays <= 4;
  return json(
    { status: healthy ? 'ok' : 'stale', lastSuccessDate: last?.target_date ?? null, lagDays, today },
    healthy ? 200 : 503,
  );
}

export async function handleRanking(env: Env, url: URL): Promise<Response> {
  const date = await resolveDate(env, url.searchParams.get('date'));
  if (date === null) return json({ error: 'スコアがまだ 1 件もありません' }, 404);

  const limit = clampInt(url.searchParams.get('limit'), 10, 1, 200);
  const verdict = url.searchParams.get('verdict') ?? undefined;
  const sector = url.searchParams.get('sector') ?? undefined;
  const minTotalRaw = url.searchParams.get('minTotal');
  const minTotal = minTotalRaw === null ? undefined : clampInt(minTotalRaw, 0, 0, 100);

  const [ranking, verdictCounts, goldenCross] = await Promise.all([
    selectRanking(env.INVEST_DB, date, { limit, verdict, sector, minTotal }),
    countVerdicts(env.INVEST_DB, date),
    countQualifiedGoldenCross(env.INVEST_DB, date, QUALIFIED_STRENGTH),
  ]);

  return json({
    date,
    scoreNote: 'total は条件への合致度であり、期待リターンではない',
    verdictCounts,
    goldenCrossCount: goldenCross,
    ranking,
  });
}

export async function handleSymbol(env: Env, url: URL, symbolId: string): Promise<Response> {
  const date = await resolveDate(env, url.searchParams.get('date'));
  if (date === null) return json({ error: 'スコアがまだ 1 件もありません' }, 404);

  const detail = await selectSymbolDetail(env.INVEST_DB, symbolId, date);
  if (detail.ranking === null) return json({ error: `銘柄が見つからない: ${symbolId}` }, 404);
  return json(detail);
}

/**
 * パイプラインの手動実行。Cron と同じ処理を呼ぶ。
 * `?force=1` を付けると、その日が成功済みでも走らせ直す。
 */
export async function handleRunPipeline(env: Env, url: URL): Promise<Response> {
  if (!env.JQUANTS_API_KEY) {
    return json({ error: 'JQUANTS_API_KEY が未設定。wrangler secret put で登録すること' }, 400);
  }
  const dateParam = url.searchParams.get('date');
  if (dateParam !== null && !isIsoDate(dateParam)) {
    return json({ error: 'date は YYYY-MM-DD 形式' }, 400);
  }
  try {
    const result = await runDailyPipeline(env, new Date(), {
      force: url.searchParams.get('force') === '1',
      ...(dateParam === null ? {} : { date: dateParam }),
    });
    return json(result);
  } catch (err) {
    return json({ error: err instanceof Error ? err.message : String(err) }, 500);
  }
}

async function resolveDate(env: Env, requested: string | null): Promise<string | null> {
  if (requested !== null && isIsoDate(requested)) return requested;
  return latestScoredDate(env.INVEST_DB);
}

function clampInt(raw: string | null, fallback: number, min: number, max: number): number {
  const n = raw === null ? NaN : Number.parseInt(raw, 10);
  if (!Number.isFinite(n)) return fallback;
  return Math.min(max, Math.max(min, n));
}
