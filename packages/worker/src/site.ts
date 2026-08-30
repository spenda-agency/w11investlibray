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
export type Site = 'lp' | 'app' | 'unknown';

export interface Resolved {
  readonly site: Site;
  /** サイト内のパス。開発時のプレフィックス `/lp` は取り除いてある。 */
  readonly path: string;
  /** 正規化のための転送先（www → apex）。設定されていれば 301 で飛ばす。 */
  readonly redirectTo?: string;
}

/**
 * ホスト名が設定されていれば、それだけで判定する。
 *
 * **設定済みなのに一致しないホストは `unknown` にして 404 を返す。**
 * ここを「とりあえずアプリ」に倒すと、想定外のホスト
 * （`*.workers.dev` など）で Access を通らずにダッシュボードが開いてしまう。
 * Access はゾーンのホスト名に紐づくので、別ホストには適用されない。
 * `wrangler.toml` の `workers_dev = false` と合わせて二重に塞いでいる。
 *
 * ホスト名が両方とも未設定のとき（ローカルの `wrangler dev`）だけ、
 * パスで振り分ける: `/lp` 配下が LP、それ以外がアプリ。
 */
export function resolveSite(url: URL, env: Env): Resolved {
  const path = normalisePath(url.pathname);
  const host = url.hostname.toLowerCase();
  const appHost = (env.APP_HOSTNAME || '').trim().toLowerCase();
  const lpHost = (env.LP_HOSTNAME || '').trim().toLowerCase();

  // ローカルは常にパス振り分け。wrangler.toml に本番のホスト名が
  // 入っていても `wrangler dev` が動くようにするため。
  // これらのホスト名は Cloudflare のルートに一致しないので、
  // 本番のリクエストがここへ落ちてくることはない。
  if (isLoopback(host)) return pathFallback(path);

  if (appHost !== '' && host === appHost) return { site: 'app', path };
  if (lpHost !== '' && host === lpHost) return { site: 'lp', path };

  // www は apex へ寄せる。両方に実体があると被リンクと評価が分散する。
  if (lpHost !== '' && host === `www.${lpHost}`) {
    return { site: 'lp', path, redirectTo: `https://${lpHost}${url.pathname}${url.search}` };
  }
  if (appHost !== '' && host === `www.${appHost}`) {
    return { site: 'app', path, redirectTo: `https://${appHost}${url.pathname}${url.search}` };
  }

  // どちらかが設定されている = 本番。想定外のホストには何も返さない。
  if (appHost !== '' || lpHost !== '') return { site: 'unknown', path };

  // 両方とも未設定。ホスト名を入れる前の状態。
  return pathFallback(path);
}

function isLoopback(host: string): boolean {
  return host === 'localhost' || host === '127.0.0.1' || host === '::1' || host.endsWith('.localhost');
}

/** `/lp` 配下が LP、それ以外がアプリ。ローカルで両方を確認するための振り分け。 */
function pathFallback(path: string): Resolved {
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

/** LP の絶対 URL。canonical と OGP と sitemap が使う。 */
export function lpUrl(env: Env, path = '/'): string {
  const lpHost = (env.LP_HOSTNAME || '').trim();
  return lpHost === '' ? path : `https://${lpHost}${path}`;
}
