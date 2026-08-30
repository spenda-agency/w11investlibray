import type { Env } from '../types.js';
import { lpPage } from '../ui/lp.js';
import { appUrl, lpBasePath, lpUrl } from '../site.js';
import { handleWaitlist } from './waitlist.js';
import { escapeHtml } from '../ui/format.js';

/**
 * LP 側のルーティング。**認証を通さない。**
 * ここから市場データに触れる経路を作らないこと（`INVEST_DB` を読むのは
 * 先行登録の書き込みだけ）。
 */
export async function handleLpRequest(
  request: Request,
  env: Env,
  path: string,
): Promise<Response> {
  const base = lpBasePath(env);
  const target = appUrl(env, '/');
  const canonical = lpUrl(env, '/');

  if (path === '/' || path === '') {
    return html(
      lpPage({
        siteName: env.SITE_NAME,
        basePath: base,
        appUrl: target,
        ...(canonical.startsWith('https://') ? { canonicalUrl: canonical } : {}),
      }),
    );
  }

  // 検索エンジン向け。**LP だけを拾わせる。**
  // ダッシュボード側は別ホストで、そちらの robots.txt は全面拒否にしてある。
  if (path === '/robots.txt') {
    const sitemap = lpUrl(env, '/sitemap.xml');
    return text(
      `User-agent: *\nAllow: /\n${sitemap.startsWith('https://') ? `Sitemap: ${sitemap}\n` : ''}`,
    );
  }

  if (path === '/sitemap.xml') {
    const root = lpUrl(env, '/');
    if (!root.startsWith('https://')) return text('', 404);
    const urls = ['/', '/privacy'].map(
      (p) => `  <url><loc>${lpUrl(env, p)}</loc></url>`,
    );
    return new Response(
      `<?xml version="1.0" encoding="UTF-8"?>\n<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">\n${urls.join('\n')}\n</urlset>\n`,
      { headers: { 'content-type': 'application/xml; charset=utf-8' } },
    );
  }

  if (path === '/api/waitlist') {
    const res = await handleWaitlist(request, env);
    // ブラウザからのフォーム送信は、JSON ではなくページを返す。
    if (wantsHtml(request)) {
      const ok = res.status === 200;
      const message = ok ? null : await errorMessage(res);
      return html(
        lpPage({
          siteName: env.SITE_NAME,
          basePath: base,
          appUrl: target,
          submitted: ok ? 'ok' : null,
          errorMessage: message,
        }),
        ok ? 200 : res.status,
      );
    }
    return res;
  }

  if (path === '/privacy') {
    return html(privacyPage(env.SITE_NAME, base));
  }

  return html(`<!doctype html><html lang="ja"><head><meta charset="utf-8">
<title>見つかりません</title></head><body>
<p>ページが見つかりません。<a href="${escapeHtml(base)}/">トップへ</a></p>
</body></html>`, 404);
}

function wantsHtml(request: Request): boolean {
  const accept = request.headers.get('accept') ?? '';
  return accept.includes('text/html');
}

async function errorMessage(res: Response): Promise<string> {
  try {
    const body = (await res.clone().json()) as { error?: unknown };
    return typeof body.error === 'string' ? body.error : '送信に失敗した';
  } catch {
    return '送信に失敗した';
  }
}

function text(body: string, status = 200): Response {
  return new Response(body, {
    status,
    headers: {
      'content-type': 'text/plain; charset=utf-8',
      'cache-control': 'public, max-age=3600',
    },
  });
}

function html(body: string, status = 200): Response {
  return new Response(body, {
    status,
    headers: {
      'content-type': 'text/html; charset=utf-8',
      'cache-control': status === 200 ? 'public, max-age=300' : 'no-store',
    },
  });
}

/**
 * プライバシーポリシーの骨格。
 * **運営者名・連絡先・保存期間は事業者が決めるもの**なので、
 * 埋めるべき箇所を角括弧で残してある。埋めずに公開しないこと。
 */
function privacyPage(siteName: string, base: string): string {
  return `<!doctype html>
<html lang="ja">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>プライバシーポリシー — ${escapeHtml(siteName)}</title>
<style>
body { margin:0 auto; padding:2.5rem 1.5rem 4rem; max-width:720px; line-height:1.8;
  font-family: system-ui, -apple-system, "Hiragino Kaku Gothic ProN", "Noto Sans JP", sans-serif;
  background:#fbfaf9; color:#1a1a19; }
@media (prefers-color-scheme: dark) { body { background:#16161a; color:#eceae6; } }
h1 { font-size:1.5rem; } h2 { font-size:1.0625rem; margin-top:2rem; }
.todo { color:#a4402f; font-weight:600; }
a { color:#2f6f4f; }
</style>
</head>
<body>
<h1>プライバシーポリシー</h1>

<h2>取得する情報</h2>
<p>先行登録の際に、メールアドレスと、お知らせの受信に同意いただいた日時を取得します。
それ以外の個人情報は取得しません。IP アドレスは保存していません。</p>

<h2>利用目的</h2>
<p>サービスの公開・提供状況のご連絡にのみ利用します。他の目的には利用しません。</p>

<h2>第三者提供</h2>
<p>ご本人の同意なく第三者へ提供することはありません。</p>

<h2>保存期間</h2>
<p><span class="todo">[保存期間を記入]</span></p>

<h2>解除</h2>
<p>配信の解除はいつでも可能です。<span class="todo">[解除方法・連絡先を記入]</span></p>

<h2>事業者</h2>
<p><span class="todo">[運営者名・所在地・連絡先を記入]</span></p>

<p><a href="${escapeHtml(base)}/">トップへ戻る</a></p>
</body>
</html>`;
}
