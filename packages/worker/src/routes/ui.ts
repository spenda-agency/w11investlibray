import { QUALIFIED_STRENGTH } from '@invest/core';
import type { Env } from '../types.js';
import {
  countQualifiedGoldenCross,
  countVerdicts,
  hasSampleData,
  latestScoredDate,
  selectRanking,
  selectSymbolDetail,
} from '../db/queries.js';
import { isAccessConfigured } from '../auth.js';
import { layout } from '../ui/layout.js';
import { dashboardPage, notFoundPage, screenerPage, symbolPage } from '../ui/pages.js';

function html(body: string, status = 200): Response {
  return new Response(body, {
    status,
    headers: { 'content-type': 'text/html; charset=utf-8', 'cache-control': 'no-store' },
  });
}

export async function handleDashboard(env: Env): Promise<Response> {
  const [date, sample] = await Promise.all([
    latestScoredDate(env.INVEST_DB),
    hasSampleData(env.INVEST_DB),
  ]);
  const data =
    date === null
      ? { date: null, top: [], verdictCounts: {}, goldenCrossCount: 0, universeSize: 0 }
      : await (async () => {
          const [top, verdictCounts, goldenCrossCount] = await Promise.all([
            selectRanking(env.INVEST_DB, date, { limit: 10 }),
            countVerdicts(env.INVEST_DB, date),
            countQualifiedGoldenCross(env.INVEST_DB, date, QUALIFIED_STRENGTH),
          ]);
          const universeSize = Object.values(verdictCounts).reduce((a, b) => a + b, 0);
          return { date, top, verdictCounts, goldenCrossCount, universeSize };
        })();

  return html(
    layout({
      title: '本日の候補',
      siteName: env.SITE_NAME,
      body: dashboardPage(data),
      accessWarning: !isAccessConfigured(env),
      sampleData: sample,
      activeNav: 'dashboard',
    }),
  );
}

export async function handleScreener(env: Env, url: URL): Promise<Response> {
  const [date, sample] = await Promise.all([
    latestScoredDate(env.INVEST_DB),
    hasSampleData(env.INVEST_DB),
  ]);
  const verdict = url.searchParams.get('verdict') ?? '';
  const sector = url.searchParams.get('sector') ?? '';
  const minTotalRaw = url.searchParams.get('minTotal') ?? '';
  const minTotal = minTotalRaw === '' ? undefined : Number.parseInt(minTotalRaw, 10);

  const rows =
    date === null
      ? []
      : await selectRanking(env.INVEST_DB, date, {
          limit: 100,
          ...(verdict === '' ? {} : { verdict }),
          ...(sector === '' ? {} : { sector }),
          ...(minTotal === undefined || !Number.isFinite(minTotal) ? {} : { minTotal }),
        });

  const sectorRes = await env.INVEST_DB.prepare(
    `SELECT DISTINCT sector33 AS s FROM symbols WHERE sector33 IS NOT NULL ORDER BY s LIMIT 40`,
  ).all<{ s: string }>();

  return html(
    layout({
      title: 'スクリーナー',
      siteName: env.SITE_NAME,
      body: screenerPage({
        date,
        rows,
        sectors: (sectorRes.results ?? []).map((r) => r.s),
        filters: { verdict, sector, minTotal: minTotalRaw },
      }),
      accessWarning: !isAccessConfigured(env),
      sampleData: sample,
      activeNav: 'screener',
    }),
  );
}

export async function handleSymbolPage(env: Env, symbolId: string): Promise<Response> {
  const date = await latestScoredDate(env.INVEST_DB);
  if (date === null) {
    return html(
      layout({ title: '銘柄', siteName: env.SITE_NAME, body: notFoundPage('データがありません。'), activeNav: null }),
      404,
    );
  }

  const detail = await selectSymbolDetail(env.INVEST_DB, symbolId, date);
  if (detail.ranking === null) {
    return html(
      layout({
        title: '銘柄',
        siteName: env.SITE_NAME,
        body: notFoundPage(`銘柄 ${symbolId} のスコアが見つかりません。`),
        accessWarning: !isAccessConfigured(env),
        activeNav: null,
      }),
      404,
    );
  }

  const score = await env.INVEST_DB.prepare(
    `SELECT score_version, c_trend, c_rsi, c_macd, c_ma, c_volume, c_momentum, c_fundamental, c_news
     FROM scores_daily WHERE symbol_id = ?1 AND date = ?2
     ORDER BY score_version DESC LIMIT 1`,
  )
    .bind(symbolId, detail.ranking.date)
    .first<Record<string, string | number | null>>();

  const signals = await env.INVEST_DB.prepare(
    `SELECT signal_code, detail FROM signals_daily WHERE symbol_id = ?1 AND date = ?2`,
  )
    .bind(symbolId, detail.ranking.date)
    .all<{ signal_code: string; detail: string | null }>();

  const parsed = new Map<string, unknown>();
  for (const row of signals.results ?? []) {
    parsed.set(row.signal_code, row.detail === null ? null : safeJson(row.detail));
  }

  return html(
    layout({
      title: detail.ranking.name,
      siteName: env.SITE_NAME,
      sampleData: await hasSampleData(env.INVEST_DB),
      body: symbolPage({
        row: detail.ranking,
        history: detail.history,
        scoreVersion: typeof score?.['score_version'] === 'string' ? score['score_version'] : '—',
        components: {
          trend: numOrNull(score?.['c_trend']),
          rsi: numOrNull(score?.['c_rsi']),
          macd: numOrNull(score?.['c_macd']),
          ma: numOrNull(score?.['c_ma']),
          volume: numOrNull(score?.['c_volume']),
          momentum: numOrNull(score?.['c_momentum']),
          fundamental: numOrNull(score?.['c_fundamental']),
          news: numOrNull(score?.['c_news']),
        },
        // Map.get は欠けているキーに undefined を返す。null と比較している
        // 描画側に undefined を渡すと詳細ページが落ちるので、ここで潰す。
        goldenCrossDetail: (parsed.get('golden_cross') ?? null) as SymbolSignalDetail,
        exitDetail: (parsed.get('exit') ?? null) as { met: string[] } | null,
      }),
      accessWarning: !isAccessConfigured(env),
      activeNav: null,
    }),
  );
}

type SymbolSignalDetail = { met: string[]; crossedToday: boolean; qualified: boolean } | null;

function numOrNull(v: unknown): number | null {
  return typeof v === 'number' ? v : null;
}

function safeJson(raw: string): unknown {
  try {
    return JSON.parse(raw);
  } catch {
    return null;
  }
}
