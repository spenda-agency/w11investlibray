import type { Env } from '../types.js';
import { countWaitlist, selectWaitlist, type WaitlistRow } from '../db/queries.js';
import { layout } from '../ui/layout.js';
import { escapeHtml } from '../ui/format.js';

/**
 * 集めた先行登録を見る / 書き出す。
 *
 * **アプリ側（Cloudflare Access の後ろ）にだけ置く。** メールアドレスは
 * 個人情報なので、LP 側から到達する経路を作らないこと。
 */

const DEFAULT_LIMIT = 200;
const MAX_LIMIT = 5000;

export async function handleWaitlistPage(env: Env): Promise<Response> {
  const [rows, counts] = await Promise.all([
    selectWaitlist(env.INVEST_DB, DEFAULT_LIMIT),
    countWaitlist(env.INVEST_DB),
  ]);
  const total = Object.values(counts).reduce((a, b) => a + b, 0);

  const body = `
<h1>先行登録</h1>
<p class="sub">${total} 件（新しい順に ${rows.length} 件を表示）</p>

<div class="cards">
  ${['pending', 'confirmed', 'unsubscribed']
    .map(
      (s) =>
        `<div class="card"><div class="k">${escapeHtml(STATUS_LABEL[s] ?? s)}</div>` +
        `<div class="v">${counts[s] ?? 0}</div></div>`,
    )
    .join('')}
</div>

<p><a href="/api/waitlist.csv">CSV で書き出す</a></p>

${
  rows.length === 0
    ? '<div class="table-wrap"><p class="empty">まだ登録がありません。</p></div>'
    : `<div class="table-wrap"><table>
  <thead><tr>
    <th class="l">メールアドレス</th><th class="l">登録日時</th>
    <th class="l">流入元</th><th class="l">状態</th>
  </tr></thead>
  <tbody>${rows
    .map(
      (r) => `<tr>
    <td class="l">${escapeHtml(r.email)}</td>
    <td class="l">${escapeHtml(r.createdAt.replace('T', ' ').slice(0, 16))}</td>
    <td class="l">${escapeHtml(r.source ?? '—')}</td>
    <td class="l">${escapeHtml(STATUS_LABEL[r.status] ?? r.status)}</td>
  </tr>`,
    )
    .join('')}</tbody>
</table></div>`
}

<p class="note" style="margin-top:1rem">
  この画面は Cloudflare Access の背後にあります。メールアドレスは個人情報です。
  書き出したファイルの取り扱いに注意してください。
</p>`;

  return new Response(
    layout({ title: '先行登録', siteName: env.SITE_SHORT_NAME, body, activeNav: 'waitlist' }),
    { status: 200, headers: { 'content-type': 'text/html; charset=utf-8', 'cache-control': 'no-store' } },
  );
}

const STATUS_LABEL: Readonly<Record<string, string>> = {
  pending: '未確認',
  confirmed: '確認済み',
  unsubscribed: '解除済み',
};

export async function handleWaitlistCsv(env: Env, url: URL): Promise<Response> {
  const raw = Number.parseInt(url.searchParams.get('limit') ?? '', 10);
  const limit = Number.isFinite(raw) ? Math.min(MAX_LIMIT, Math.max(1, raw)) : MAX_LIMIT;
  const rows = await selectWaitlist(env.INVEST_DB, limit);

  const header = ['email', 'created_at', 'consented_at', 'source', 'status'];
  const lines = [header.join(',')];
  for (const r of rows) lines.push(toCsvRow(r));

  // BOM を付ける。Excel が UTF-8 と判定できず日本語が化けるのを防ぐ。
  return new Response(`\uFEFF${lines.join('\r\n')}\r\n`, {
    headers: {
      'content-type': 'text/csv; charset=utf-8',
      'content-disposition': `attachment; filename="waitlist-${new Date().toISOString().slice(0, 10)}.csv"`,
      'cache-control': 'no-store',
    },
  });
}

function toCsvRow(r: WaitlistRow): string {
  return [r.email, r.createdAt, r.consentedAt, r.source ?? '', r.status].map(csvCell).join(',');
}

/**
 * CSV の 1 セル。
 *
 * **`=` `+` `-` `@` で始まる値は `'` を前置する。** 表計算ソフトが
 * 数式として解釈して実行してしまう（CSV インジェクション）。
 * メールアドレスは利用者が入力した値なので、ここを素通しにできない。
 */
export function csvCell(value: string): string {
  const escaped = /^[=+\-@\t\r]/.test(value) ? `'${value}` : value;
  return `"${escaped.replace(/"/g, '""')}"`;
}
