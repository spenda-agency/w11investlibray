import { escapeHtml } from './format.js';
import { FONT_STACK, TOKENS } from './tokens.js';

/**
 * 先行登録の LP。**市場データを一切出さない公開ページ。**
 *
 * 表現の制約が本文の書き方を決めている。
 *   - 「儲かる」「推奨」と書かない。書けるのは「条件に合致した候補」まで
 *   - スコアは条件への合致度であって期待リターンではない、と本文で言い切る
 *   - できないこと・やらないことを隠さない。ここが差別化そのもの
 *
 * 見た目は `packages/worker/src/ui/layout.ts` と同じ配色トークンを使っている。
 * **Claude Design のテンプレートが入ったら、この STYLES と各節のマークアップを
 * 差し替える。** 本文（コピー）はテンプレートが変わっても使い回せる。
 */

export interface LpOptions {
  readonly siteName: string;
  readonly basePath: string;
  readonly appUrl: string;
  /** 送信後の再表示。`ok` なら完了メッセージ、`error` なら理由を出す。 */
  readonly submitted?: 'ok' | null;
  readonly errorMessage?: string | null;
}

export function lpPage(o: LpOptions): string {
  const action = `${o.basePath}/api/waitlist`;
  return `<!doctype html>
<html lang="ja">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>${escapeHtml(o.siteName)} — 毎日、全銘柄を同じ物差しで測る</title>
<meta name="description" content="5,000 銘柄を毎日機械的にスクリーニングし、条件に合致した候補とその根拠を 1 画面に集約する投資判断支援システム。先行登録を受け付けています。">
<meta property="og:title" content="${escapeHtml(o.siteName)}">
<meta property="og:description" content="毎日、全銘柄を同じ物差しで測る。条件に合致した候補と、その根拠まで。">
<meta property="og:type" content="website">
<style>${TOKENS}${STYLES}</style>
</head>
<body>

<header class="lp-head">
  <span class="brand">${escapeHtml(o.siteName)}</span>
  <a class="quiet" href="${escapeHtml(o.appUrl)}">ログイン</a>
</header>

<main>

<section class="hero">
  <h1>毎日、全銘柄を<br>同じ物差しで測る。</h1>
  <p class="lede">
5,000 銘柄について毎日おなじ計算を回し、条件に合致した候補を機械的に抽出します。「なぜ今この銘柄なのか」を、指標の内訳まで開いて示します。
  </p>
  ${formBlock(action, o, 'hero')}
</section>

<section class="band">
  <h2>やっていること</h2>
  <ol class="steps">
    <li>
      <span class="step-n">1</span>
      <h3>毎日、機械的に計算する</h3>
      <p>
RSI・MACD・移動平均・ATR・出来高を、全銘柄について毎営業日そのまま計算します。ここに AI は使いません。同じ入力からは必ず同じ結果が出ます。
      </p>
    </li>
    <li>
      <span class="step-n">2</span>
      <h3>条件を重ねて絞る</h3>
      <p>
「5 日線が 25 日線を上抜けた」だけでは候補にしません。25 日線の向き、株価と 75 日線の位置、MACD、RSI の水準、出来高——8 つの条件のうちいくつ揃ったかで判定します。
      </p>
    </li>
    <li>
      <span class="step-n">3</span>
      <h3>根拠ごと出す</h3>
      <p>
スコアの内訳、合致した条件、ATR から機械的に決めた損切り・利確の水準まで表示します。数字の出どころを追えます。
      </p>
    </li>
  </ol>
</section>

<section class="band alt">
  <h2>やらないこと</h2>
  <p class="lede">ここが、よくある株式スクリーナーとの違いです。</p>
  <ul class="nots">
    <li>
      <h3>AI に株価を予測させない</h3>
      <p>AI の役割はニュースの分類・要約・説明に限ります。値動きの予測はさせません。</p>
    </li>
    <li>
      <h3>スコアを「期待リターン」と呼ばない</h3>
      <p>スコアは条件への合致度です。何 % 上がるかを表す数字ではありません。</p>
    </li>
    <li>
      <h3>検証していないルールを推奨しない</h3>
      <p>
過去データで検証していないルールを「おすすめ」として表示しません。検証では、その時点で入手できた情報だけを使います。
      </p>
    </li>
    <li>
      <h3>上場廃止した銘柄を消さない</h3>
      <p>
生き残った銘柄だけで検証すると、成績が実態より良く出ます。廃止された銘柄も残したまま検証します。
      </p>
    </li>
  </ul>
</section>

<section class="band">
  <h2>いまの状態</h2>
  <p class="lede">
日本株を対象に、日足・テクニカル指標・スコアリング・画面までが動いています。ニュース分析、米国株、FX、バックテストの公開はこれからです。
  </p>
  <p class="note">
公開範囲は市場データの提供元との取り決めを確認しながら決めています。準備ができた順にご案内します。
  </p>
</section>

<section class="signup" id="signup">
  <h2>先行登録</h2>
  <p class="lede">公開の準備ができたらお知らせします。メールアドレスだけで登録できます。</p>
  ${formBlock(action, o, 'footer')}
</section>

</main>

<footer class="lp-foot">
  <p class="disclaimer">
本サービスは情報提供および投資判断の支援を目的としたものであり、特定の銘柄の売買を勧誘するものではありません。表示されるスコアおよびシグナルは、過去データに基づく機械的な計算結果であり、将来の価格や収益を保証するものではありません。<strong>投資判断はご自身の責任で行ってください。</strong>
  </p>
  <p class="quiet">
    運営: [運営者名を記入] ／ お問い合わせ: [連絡先を記入] ／
    <a href="${escapeHtml(o.basePath)}/privacy">プライバシーポリシー</a>
  </p>
</footer>

</body>
</html>`;
}

/**
 * 登録フォーム。ページ内に 2 か所置くので、id が衝突しないよう接尾辞を取る。
 *
 * `company` は人には見えないハニーポット。自動投稿だけが埋める。
 */
function formBlock(action: string, o: LpOptions, suffix: string): string {
  if (o.submitted === 'ok') {
    return `<div class="done" role="status">
      <strong>登録を受け付けました。</strong>
      公開の準備ができましたらご連絡します。
    </div>`;
  }
  const emailId = `email-${suffix}`;
  const consentId = `consent-${suffix}`;
  return `<form class="signup-form" method="post" action="${escapeHtml(action)}">
  ${o.errorMessage ? `<p class="error" role="alert">${escapeHtml(o.errorMessage)}</p>` : ''}
  <input type="hidden" name="source" value="lp">
  <div class="hp" aria-hidden="true">
    <label for="company-${suffix}">会社名（入力しないでください）</label>
    <input id="company-${suffix}" type="text" name="company" tabindex="-1" autocomplete="off">
  </div>
  <div class="row">
    <label class="sr-only" for="${emailId}">メールアドレス</label>
    <input id="${emailId}" type="email" name="email" required autocomplete="email"
           placeholder="you@example.com" maxlength="254">
    <button type="submit">先行登録する</button>
  </div>
  <label class="consent" for="${consentId}">
    <input id="${consentId}" type="checkbox" name="consent" required>
    <span>公開のお知らせをメールで受け取ることに同意します。いつでも解除できます。</span>
  </label>
</form>`;
}

/**
 * LP 側の見た目。パレットは tokens.ts が持つ。
 * ここに残すのは LP 固有の値だけ。
 *
 * **デザインテンプレートを当てるときに差し替えるのはこの STYLES と
 * 各節のマークアップ。** 本文（コピー）はそのまま持っていける。
 */
const STYLES = `
:root {
  /* 本文の 1 カラム幅。LP だけが使う */
  --maxw: 720px;
}
body {
  margin: 0; background: var(--bg); color: var(--ink);
  font-family: ${FONT_STACK};
  font-size: 16px; line-height: 1.75; text-wrap: pretty;
}
a { color: var(--accent); }
a:hover { opacity: .8; }
.quiet { color: var(--muted); font-size: .875rem; text-decoration: none; }

.lp-head {
  display: flex; justify-content: space-between; align-items: center;
  padding: 1.1rem 1.5rem; border-bottom: 1px solid var(--line);
}
.brand { font-weight: 700; letter-spacing: .02em; }

main { }
/*
 * 中身は「中央に寄せた 1 カラム」に流す。
 * section > * に margin-inline:auto を掛けると、見出しや段落の
 * margin: 0 0 1rem という一括指定が margin-inline を 0 に戻してしまい、
 * 見出しだけ左端に寄る（実際にそうなっていた）。グリッドなら
 * 子側の margin の書き方に左右されない。
 */
section {
  padding: 3.5rem 1.5rem;
  display: grid;
  grid-template-columns: minmax(0, var(--maxw));
  justify-content: center;
}
.band { border-top: 1px solid var(--line); }
.band.alt { background: var(--panel); }

.hero { padding-top: 4.5rem; padding-bottom: 3rem; }
.hero h1 {
  font-size: clamp(2rem, 6vw, 3rem); line-height: 1.25; margin: 0 0 1rem;
  letter-spacing: -.01em; font-weight: 700;
}
.lede { font-size: 1.0625rem; color: var(--muted); margin: 0 0 2rem; }
h2 { font-size: 1.375rem; margin: 0 0 1.25rem; letter-spacing: -.005em; }
h3 { font-size: 1rem; margin: 0 0 .35rem; }

.steps { list-style: none; margin: 0; padding: 0; display: grid; gap: 1.75rem; }
.steps li { display: grid; grid-template-columns: 2rem 1fr; gap: 0 1rem; }
.step-n {
  grid-row: span 2; display: grid; place-items: center;
  width: 2rem; height: 2rem; border-radius: 100px;
  border: 1px solid var(--accent); color: var(--accent);
  font-size: .875rem; font-variant-numeric: tabular-nums;
}
.steps p, .nots p { margin: 0; color: var(--muted); }

.nots { list-style: none; margin: 0; padding: 0; display: grid; gap: 1.5rem; }
.nots li { padding-left: 1.1rem; border-left: 2px solid var(--line); }

.signup { border-top: 1px solid var(--line); }
.signup-form { display: grid; gap: .85rem; }
.row { display: flex; gap: .6rem; flex-wrap: wrap; }
input[type="email"] {
  flex: 1 1 16rem; min-width: 0; font: inherit; font-size: 1rem;
  padding: .7rem .85rem; border: 1px solid var(--line); border-radius: 8px;
  background: var(--panel); color: var(--ink); min-height: 48px;
}
input[type="email"]:focus-visible { outline: 2px solid var(--accent); outline-offset: 1px; }
button {
  font: inherit; font-size: 1rem; font-weight: 600; cursor: pointer;
  padding: .7rem 1.4rem; border-radius: 8px; min-height: 48px;
  border: 1px solid var(--accent); background: var(--accent); color: var(--bg);
}
button:hover { opacity: .9; }
.consent {
  display: flex; gap: .55rem; align-items: flex-start;
  font-size: .875rem; color: var(--muted);
}
.consent input { margin-top: .35rem; width: 18px; height: 18px; flex: none; }
.done {
  padding: 1rem 1.15rem; border-radius: 8px;
  border: 1px solid var(--accent);
  background: color-mix(in srgb, var(--accent) 12%, transparent);
}
.error { color: var(--danger); margin: 0; font-size: .9rem; }

/* 人には見せない。自動投稿だけが埋める項目。 */
.hp { position: absolute; left: -9999px; width: 1px; height: 1px; overflow: hidden; }
.sr-only {
  position: absolute; width: 1px; height: 1px; padding: 0; margin: -1px;
  overflow: hidden; clip: rect(0 0 0 0); white-space: nowrap; border: 0;
}

.note { font-size: .875rem; color: var(--muted); margin: 0; }
.lp-foot {
  border-top: 1px solid var(--line); padding: 2rem 1.5rem 3rem;
  display: grid; grid-template-columns: minmax(0, var(--maxw)); justify-content: center;
}
.disclaimer { font-size: .8125rem; color: var(--muted); margin: 0 0 .75rem; }
`;
