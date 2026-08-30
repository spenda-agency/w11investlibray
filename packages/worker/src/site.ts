import type { Env } from './types.js';

/**
 * LP とアプリをホスト名で分ける。
 *
 *   example.com      → LP（誰でも見られる。市場データは一切出さない）
 *   app.example.com  → ダッシュボード（Cloudflare Access の後ろ）
 *
 * 分けている理由は認証の事故を防ぐため。同じホストでパスだけ分けると、
 * Access のポリシーをパス単位で書くことになり、ルートを 1 本足しただけで
 * 市場データが公開側に漏れる余地が生まれる。**ホストが違えば Access の
 * 適用範囲もホスト単位で済む。**
 */
export type Site = 'lp' | 'app';

export interface Resolved {
  readonly site: Site;
  /** サイト内のパス。開発時のプレフィックス `/lp` は取り除いてある。 */
  readonly path: string;
}

/**
 * ホスト名が設定されていれば、それで判定する。
 *
 * 未設定のとき（ローカルの `wrangler dev` や workers.dev）は
 * **パスで振り分ける**: `/lp` 配下が LP、それ以外がアプリ。
 * 本番と開発で LP の URL が変わるが、ホストを 2 つ用意しないと
 * ローカルで両方を確認できないため、ここは割り切っている。
 */
export function resolveSite(url: URL, env: Env): Resolved {
  const path = normalisePath(url.pathname);
  const host = url.hostname.toLowerCase();
  const appHost = (env.APP_HOSTNAME || '').trim().toLowerCase();
  const lpHost = (env.LP_HOSTNAME || '').trim().toLowerCase();

  if (appHost !== '' && host === appHost) return { site: 'app', path };
  if (lpHost !== '' && host === lpHost) return { site: 'lp', path };

  // ホスト未設定。開発用のパス振り分け。
  if (path === '/lp') return { site: 'lp', path: '/' };
  if (path.startsWith('/lp/')) return { site: 'lp', path: path.slice(3) };
  return { site: 'app', path };
}

/** 末尾スラッシュを落として `/` に正規化する。 */
export function normalisePath(pathname: string): string {
  const trimmed = pathname.replace(/\/+$/, '');
  return trimmed === '' ? '/' : trimmed;
}

/**
 * LP 内のリンクに付ける接頭辞。
 * ホスト分割が効いていれば空、開発時のパス振り分けなら `/lp`。
 */
export function lpBasePath(env: Env): string {
  return (env.LP_HOSTNAME || '').trim() === '' ? '/lp' : '';
}

/** アプリ側の絶対 URL。LP から「ログイン」で飛ばすときに使う。 */
export function appUrl(env: Env, path = '/'): string {
  const appHost = (env.APP_HOSTNAME || '').trim();
  return appHost === '' ? path : `https://${appHost}${path}`;
}
