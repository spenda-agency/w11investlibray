import type { Env } from './types.js';
import { authenticate, isMemberSignupEnabled } from './auth.js';
import { handleHealth, handleRanking, handleRunPipeline, handleSymbol, json } from './routes/api.js';
import { handleDashboard, handleScreener, handleSymbolPage } from './routes/ui.js';
import { runDailyPipeline } from './jobs/dailyPipeline.js';

/**
 * エントリポイント。
 *
 * 認証は `/api/health` だけ外す（監視から叩くため）。それ以外は
 * Cloudflare Access の背後に置く。会員機能は実装してあるが
 * `MEMBER_SIGNUP_ENABLED` で閉じてある（docs/DATA-SOURCES.md）。
 */
export default {
  async fetch(request: Request, env: Env, ctx: ExecutionContext): Promise<Response> {
    const url = new URL(request.url);
    const path = url.pathname.replace(/\/+$/, '') || '/';

    // 監視用。ここだけ認証不要。内部の数字は返さない。
    if (path === '/api/health') return handleHealth(env);

    const auth = await authenticate(request, env);
    if (!auth.ok) {
      return json({ error: '認証が必要', reason: auth.reason }, 401);
    }

    try {
      if (path === '/') return await handleDashboard(env);
      if (path === '/screener') return await handleScreener(env, url);

      const symbolPageMatch = /^\/symbol\/(.+)$/.exec(path);
      if (symbolPageMatch?.[1] !== undefined) {
        return await handleSymbolPage(env, decodeURIComponent(symbolPageMatch[1]));
      }

      if (path === '/api/ranking') return await handleRanking(env, url);

      const symbolApiMatch = /^\/api\/symbol\/(.+)$/.exec(path);
      if (symbolApiMatch?.[1] !== undefined) {
        return await handleSymbol(env, url, decodeURIComponent(symbolApiMatch[1]));
      }

      if (path === '/api/run-pipeline') {
        if (request.method !== 'POST') {
          return json({ error: 'POST で呼ぶこと' }, 405);
        }
        return await handleRunPipeline(env, url);
      }

      // 会員機能は Phase 7。**規約の確認が済むまで開けない。**
      if (path.startsWith('/member')) {
        return json(
          {
            error: isMemberSignupEnabled(env)
              ? '会員機能は Phase 7 で実装する'
              : '会員機能は現在無効。docs/DATA-SOURCES.md の再配信条件を確認するまで開けない',
          },
          isMemberSignupEnabled(env) ? 501 : 403,
        );
      }

      return json({ error: `見つからない: ${path}` }, 404);
    } catch (err) {
      // 例外の中身をそのまま返さない（内部構造やキーが漏れうる）。
      console.error('unhandled', err);
      ctx.waitUntil(Promise.resolve());
      return json({ error: '内部エラー' }, 500);
    }
  },

  /**
   * 日次パイプライン。Cron から呼ばれる。
   *
   * 19:30 JST に本走、翌 07:00 JST に取りこぼしの回収。
   * その日が成功済みなら `job_runs` を見てスキップするので、
   * 2 度走っても二重に書かない。
   */
  async scheduled(event: ScheduledController, env: Env, ctx: ExecutionContext): Promise<void> {
    ctx.waitUntil(
      runDailyPipeline(env, new Date(event.scheduledTime)).then(
        (result) => {
          console.log('daily_pipeline', JSON.stringify(result));
        },
        (err: unknown) => {
          // ここで握り潰さない。job_runs には error が記録済みで、
          // /api/health が stale を返すようになる。
          console.error('daily_pipeline failed', err);
        },
      ),
    );
  },
} satisfies ExportedHandler<Env>;
