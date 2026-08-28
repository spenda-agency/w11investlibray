import type { Bar } from '@invest/core';
import { COMPONENT_MAX } from '@invest/core';
import type { RankingRow } from '../types.js';
import { escapeHtml, num, pct, price, verdictClass, verdictLabel } from './format.js';
import { sparkline } from './sparkline.js';

export interface DashboardData {
  readonly date: string | null;
  readonly top: readonly RankingRow[];
  readonly verdictCounts: Readonly<Record<string, number>>;
  readonly goldenCrossCount: number;
  readonly universeSize: number;
}

export function dashboardPage(d: DashboardData): string {
  if (d.date === null) return emptyState();

  const cards = [
    ['対象銘柄', String(d.universeSize)],
    ['条件合致', String(d.verdictCounts['BUY_NOW'] ?? 0)],
    ['条件待ち', String(d.verdictCounts['BUY_WATCH'] ?? 0)],
    ['ゴールデンクロス', String(d.goldenCrossCount)],
  ]
    .map(([k, v]) => `<div class="card"><div class="k">${escapeHtml(k ?? '')}</div><div class="v">${escapeHtml(v ?? '')}</div></div>`)
    .join('');

  return `
<h1>本日の候補</h1>
<p class="sub">${escapeHtml(d.date)} 時点。スコアは条件への合致度で、期待リターンではありません。</p>
<div class="cards">${cards}</div>
<h2>スコア上位</h2>
${rankingTable(d.top)}
<p class="note" style="margin-top:1rem">
  ゴールデンクロスの件数は、8 つの条件のうち 6 つ以上が揃ったものだけを数えています。
  単純に 5 日線が 25 日線を上抜けただけのものは含みません。
</p>`;
}

export function rankingTable(rows: readonly RankingRow[]): string {
  if (rows.length === 0) {
    return `<div class="table-wrap"><p class="empty">該当する銘柄がありません。</p></div>`;
  }
  const body = rows
    .map((r, i) => {
      return `<tr>
  <td class="rank">${i + 1}</td>
  <td class="l"><a href="/symbol/${encodeURIComponent(r.symbolId)}">${escapeHtml(r.name)}</a>
    <span class="rank">${escapeHtml(r.code)}</span></td>
  <td class="num score">${r.total === null ? '—' : r.total}</td>
  <td><span class="badge ${verdictClass(r.verdict)}">${escapeHtml(verdictLabel(r.verdict))}</span></td>
  <td class="num">${num(r.rsi14, 0)}</td>
  <td class="num">${r.macdHist === null ? '—' : r.macdHist > 0 ? '強気' : '弱気'}</td>
  <td class="num">${r.volRatio === null ? '—' : `${r.volRatio.toFixed(2)}倍`}</td>
  <td class="num">${r.goldenCrossStrength === null ? '—' : `${r.goldenCrossStrength}/8`}</td>
  <td class="num">${price(r.close)}</td>
</tr>`;
    })
    .join('');

  return `<div class="table-wrap"><table>
  <thead><tr>
    <th class="l">#</th><th class="l">銘柄</th><th class="num">スコア</th><th>判定</th>
    <th class="num">RSI</th><th class="num">MACD</th><th class="num">出来高</th>
    <th class="num">GC条件</th><th class="num">終値</th>
  </tr></thead>
  <tbody>${body}</tbody>
</table></div>`;
}

export interface ScreenerData {
  readonly date: string | null;
  readonly rows: readonly RankingRow[];
  readonly sectors: readonly string[];
  readonly filters: { verdict: string; sector: string; minTotal: string };
}

export function screenerPage(d: ScreenerData): string {
  if (d.date === null) return emptyState();

  const verdictOptions = ['', 'BUY_NOW', 'BUY_WATCH', 'WATCH', 'AVOID']
    .map(
      (v) =>
        `<option value="${v}"${d.filters.verdict === v ? ' selected' : ''}>${
          v === '' ? 'すべて' : escapeHtml(verdictLabel(v))
        }</option>`,
    )
    .join('');
  const sectorOptions = ['', ...d.sectors]
    .map(
      (s) =>
        `<option value="${escapeHtml(s)}"${d.filters.sector === s ? ' selected' : ''}>${
          s === '' ? 'すべて' : escapeHtml(s)
        }</option>`,
    )
    .join('');

  return `
<h1>スクリーナー</h1>
<p class="sub">${escapeHtml(d.date)} 時点 / ${d.rows.length} 件</p>
<form class="filters" method="get" action="/screener">
  <label>判定<select name="verdict">${verdictOptions}</select></label>
  <label>業種<select name="sector">${sectorOptions}</select></label>
  <label>スコア下限<input type="number" name="minTotal" min="0" max="100" step="5" value="${escapeHtml(d.filters.minTotal)}"></label>
  <button type="submit">絞り込む</button>
</form>
${rankingTable(d.rows)}`;
}

export interface SymbolPageData {
  readonly row: RankingRow;
  readonly history: readonly Bar[];
  readonly components: Readonly<Record<string, number | null>>;
  readonly scoreVersion: string;
  readonly goldenCrossDetail: { met: string[]; crossedToday: boolean; qualified: boolean } | null;
  readonly exitDetail: { met: string[] } | null;
}

const COMPONENT_LABEL: Readonly<Record<string, string>> = {
  trend: 'トレンド',
  rsi: 'RSI',
  macd: 'MACD',
  ma: '移動平均',
  volume: '出来高',
  momentum: 'モメンタム',
  fundamental: 'ファンダメンタル',
  news: 'ニュース',
};

const CONDITION_LABEL: Readonly<Record<string, string>> = {
  sma5_above_sma25: '5日線 > 25日線',
  sma25_rising: '25日線が上向き',
  close_above_sma25: '株価 > 25日線',
  close_above_sma75: '株価 > 75日線',
  macd_above_signal: 'MACD > シグナル',
  hist_positive: 'ヒストグラムがプラス',
  rsi_in_band: 'RSI 50〜70',
  volume_expanding: '出来高が増加',
  rsi_overbought: 'RSI 75超（買われすぎ）',
  macd_dead_cross: 'MACD デッドクロス',
  below_sma25: '25日線割れ',
  sma25_falling: '25日線が下向き',
};

export function symbolPage(d: SymbolPageData): string {
  const r = d.row;
  const closes = d.history.map((b) => b.close);

  const componentRows = (Object.keys(COMPONENT_MAX) as (keyof typeof COMPONENT_MAX)[])
    .map((name) => {
      const value = d.components[name] ?? null;
      const max = COMPONENT_MAX[name];
      const width = value === null ? 0 : (value / max) * 100;
      return `<dt>${escapeHtml(COMPONENT_LABEL[name] ?? name)}</dt>
        <dd>${value === null ? '<span class="rank">未評価</span>' : `${value} / ${max}`}
          <div class="bar"><span style="width:${width.toFixed(0)}%"></span></div></dd>`;
    })
    .join('');

  const gc = d.goldenCrossDetail;
  const gcList =
    gc === null || !Array.isArray(gc.met)
      ? '<p class="rank">シグナルの記録がありません。</p>'
      : `<p class="rank">${gc.met.length}/8 条件に合致${gc.crossedToday ? ' / 本日クロス' : ''}${
          gc.qualified ? ' / トレンド転換を伴う' : ''
        }</p><ul>${gc.met
          .map((m) => `<li>${escapeHtml(CONDITION_LABEL[m] ?? m)}</li>`)
          .join('')}</ul>`;

  const exitList =
    d.exitDetail === null || !Array.isArray(d.exitDetail.met) || d.exitDetail.met.length === 0
      ? '<p class="rank">現時点で手仕舞い条件には当たっていません。</p>'
      : `<ul>${d.exitDetail.met
          .map((m) => `<li>${escapeHtml(CONDITION_LABEL[m] ?? m)}</li>`)
          .join('')}</ul>`;

  return `
<h1>${escapeHtml(r.name)} <span class="rank">${escapeHtml(r.code)}</span></h1>
<p class="sub">${escapeHtml(r.sector33 ?? '業種不明')} / ${escapeHtml(r.date)} 時点
  <span class="badge ${verdictClass(r.verdict)}">${escapeHtml(verdictLabel(r.verdict))}</span></p>

<div class="cards">
  <div class="card"><div class="k">総合スコア</div><div class="v">${r.total === null ? '—' : r.total}</div></div>
  <div class="card"><div class="k">終値</div><div class="v">${price(r.close)}</div></div>
  <div class="card"><div class="k">RSI</div><div class="v">${num(r.rsi14, 0)}</div></div>
  <div class="card"><div class="k">出来高</div><div class="v">${r.volRatio === null ? '—' : `${r.volRatio.toFixed(1)}倍`}</div></div>
</div>

<div class="grid2">
  <div class="panel">
    <h3>スコアの内訳（${escapeHtml(d.scoreVersion)}）</h3>
    <dl class="kv">${componentRows}</dl>
    <p class="note" style="margin-top:.75rem">
      「未評価」の項目は 0 点ではなく、正規化の分母から外れています。
    </p>
  </div>
  <div class="panel">
    <h3>売買の目安</h3>
    <dl class="kv">
      <dt>エントリー</dt><dd>${price(r.entryPx)}</dd>
      <dt>損切り</dt><dd>${price(r.stopPx)}</dd>
      <dt>利確</dt><dd>${price(r.targetPx)}</dd>
      <dt>リスクリワード</dt><dd>${r.rr === null ? '—' : `${r.rr.toFixed(2)}`}</dd>
      <dt>損切りまで</dt><dd>${
        r.stopPx === null || r.entryPx === null ? '—' : pct(r.stopPx / r.entryPx - 1)
      }</dd>
      <dt>利確まで</dt><dd>${
        r.targetPx === null || r.entryPx === null ? '—' : pct(r.targetPx / r.entryPx - 1)
      }</dd>
    </dl>
    <p class="note" style="margin-top:.75rem">
      ATR（値動きの幅）から機械的に算出しています。将来の価格を予測したものではありません。
    </p>
  </div>
</div>

<h2>直近の値動き</h2>
<div class="panel">${sparkline(closes, 640, 90) || '<p class="rank">価格データが足りません。</p>'}
  <p class="note">直近 ${d.history.length} 営業日の終値。</p>
</div>

<div class="grid2" style="margin-top:1rem">
  <div class="panel"><h3>ゴールデンクロスの条件</h3>${gcList}</div>
  <div class="panel"><h3>手仕舞いの条件</h3>${exitList}</div>
</div>`;
}

export function emptyState(): string {
  return `
<h1>データがありません</h1>
<p class="sub">まだ日次パイプラインが 1 度も成功していません。</p>
<div class="panel">
  <p>次のいずれかを実行してください。</p>
  <dl class="kv" style="grid-template-columns:auto;text-align:left">
    <dt><code>npm run db:seed:local</code></dt>
    <dd style="text-align:left">サンプルデータを入れて画面を確認する</dd>
    <dt><code>POST /api/run-pipeline</code></dt>
    <dd style="text-align:left">日次パイプラインを手動で 1 回走らせる（要 JQUANTS_API_KEY）</dd>
  </dl>
</div>`;
}

export function notFoundPage(message: string): string {
  return `<h1>見つかりません</h1><p class="sub">${escapeHtml(message)}</p>`;
}
