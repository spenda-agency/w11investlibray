/**
 * 全レスポンスに被せる保安ヘッダー。
 *
 * **`index.ts` の出口 1 箇所で包む。** 個々のルートで付けて回ると、
 * ルートを 1 本足したときに付け忘れる。
 */

/**
 * Content-Security-Policy。
 *
 * **`script-src 'none'` にできるのは、この画面に JavaScript が 1 行も無いから。**
 *   - LP のフォームは JS 無しで動く（送信するとページが返る）
 *   - ダッシュボードのスパークラインはインライン SVG 要素で描いている
 * かなり強い防御なので、`test/headers.test.mjs` がこれを固定している。
 * 後から不用意に JS を足せばテストが落ちる。
 *
 * `style-src` に `'unsafe-inline'` が要るのは `<style>` を埋め込んでいるため。
 * nonce 方式にもできるが、HTML をキャッシュ可能にしている（LP は max-age=300）
 * ので、リクエストごとに変わる nonce とは噛み合わない。
 * スクリプトが無くインラインスタイルだけなら実害は小さい。
 *
 * LP だけは Web フォント（Noto Sans JP）を読むので `LP_CSP` を使う。
 */
export const CSP = [
  "default-src 'none'",
  "script-src 'none'",
  "style-src 'unsafe-inline'",
  "img-src 'self' data:",
  // フォームの送信先を自分自身に限る。差し替えられても外へ飛ばない。
  "form-action 'self'",
  // クリックジャッキング対策。iframe に入れさせない。
  "frame-ancestors 'none'",
  "base-uri 'none'",
].join('; ');

/**
 * LP だけに被せる CSP。**`CSP` との差は Google Fonts の 2 ホストだけ。**
 *
 * デザイン指定の書体（Noto Sans JP）を読むために、
 * `style-src` に `https://fonts.googleapis.com`（@font-face を書いた CSS）、
 * `font-src` に `https://fonts.gstatic.com`（フォント本体）を足してある。
 *
 * **ダッシュボード側には足さない。** あちらは Access の内側で、
 * 外部への通信を 1 本も持たせたくない。`script-src 'none'` は LP でも同じ。
 *
 * この 2 ホストを開けた分、訪問者の IP が Google に渡る。
 * `/privacy` の「外部サービス」にそう書いてある。
 * 書体をやめるなら、この定数と `ui/lp.ts` の `<link>` を一緒に消すこと。
 */
export const LP_CSP = [
  "default-src 'none'",
  "script-src 'none'",
  "style-src 'unsafe-inline' https://fonts.googleapis.com",
  "font-src https://fonts.gstatic.com",
  "img-src 'self' data:",
  "form-action 'self'",
  "frame-ancestors 'none'",
  "base-uri 'none'",
].join('; ');

export const SECURITY_HEADERS: Readonly<Record<string, string>> = {
  'content-security-policy': CSP,
  // Content-Type を推測させない。text/plain を HTML として実行されるのを防ぐ。
  'x-content-type-options': 'nosniff',
  // 外部サイトへ遷移するときにパスを渡さない。
  'referrer-policy': 'strict-origin-when-cross-origin',
  // frame-ancestors と重複するが、古いブラウザ向けに残す。
  'x-frame-options': 'DENY',
  'strict-transport-security': 'max-age=31536000; includeSubDomains',
};

/**
 * 応答に保安ヘッダーを足して返す。
 *
 * **既にある値を上書きしない。** 個別のルートが意図的に別の値を
 * 設定している場合（将来 CSP を緩める必要が出た画面など）を尊重する。
 */
export function withSecurityHeaders(response: Response): Response {
  // 3xx は本文を持たず、ヘッダーを足す意味が薄い。素通しする。
  if (response.status >= 300 && response.status < 400) return response;

  const headers = new Headers(response.headers);
  for (const [key, value] of Object.entries(SECURITY_HEADERS)) {
    if (!headers.has(key)) headers.set(key, value);
  }
  return new Response(response.body, {
    status: response.status,
    statusText: response.statusText,
    headers,
  });
}
