/**
 * デザイントークン。**配色と書体はここが唯一の定義。**
 *
 * LP（`lp.ts`）とダッシュボード（`layout.ts`）が同じ値を別々に持っていると、
 * 配色を変えたときに片方だけ取り残される。**LP とアプリで色がずれる**のが
 * いちばん見苦しい壊れ方なので、パレットは 1 箇所に寄せてある。
 *
 * デザインテンプレートを当てるときに触るのはこのファイル。
 * 各ページ固有の値（LP の `--maxw` など）だけ、それぞれの側に置く。
 *
 * `test/tokens.test.mjs` が、他のファイルでパレットを再定義していないことを
 * 検査している。
 */

/** 本文の書体。和文が読める順に並べる。 */
export const FONT_STACK =
  'system-ui, -apple-system, "Hiragino Kaku Gothic ProN", "Noto Sans JP", sans-serif';

/**
 * すべてのページの先頭に入れる。パレット、ダークの上書き、最小限のリセット。
 *
 * 色は「役割」で名前を付けてある（`--accent` であって `--green` ではない）。
 * テンプレートの色に差し替えても、使う側のコードを直さずに済む。
 */
export const TOKENS = `
:root {
  /* 地と文字 */
  --bg: #fbfaf9;
  --panel: #ffffff;
  --ink: #1a1a19;
  --muted: #6b6a67;
  --line: #e5e3df;

  /* 役割色 */
  --accent: #2f6f4f;
  --danger: #a4402f;
  --warn: #8a6d1f;

  /* 相場の上下。--accent / --danger と同値だが、意味が違うので分けてある
     （テンプレート次第で赤緑を入れ替えることがある） */
  --up: #2f6f4f;
  --down: #a4402f;

  --radius: 10px;
}
@media (prefers-color-scheme: dark) {
  :root {
    --bg: #16161a;
    --panel: #1e1e23;
    --ink: #eceae6;
    --muted: #9b9a96;
    --line: #32323a;

    --accent: #6dbd92;
    --danger: #e08272;
    --warn: #d9b45c;

    --up: #6dbd92;
    --down: #e08272;
  }
}
* { box-sizing: border-box; }
`;
