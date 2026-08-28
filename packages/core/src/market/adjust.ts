import type { PriceRow } from './source.js';

/**
 * 株式分割の調整。
 *
 * J-Quants の `AdjustmentFactor` は「その日に適用された分割比率」なので、
 * **将来側から累積**して過去の価格に掛ける。1:2 分割なら factor = 0.5 で、
 * それより前の価格を半分にすると系列が連続する。
 *
 * ここを間違えると、分割日をまたいだ瞬間に移動平均とゴールデンクロスが
 * 一斉に誤爆する。`w09jquantsclaude` が
 * `tests/test_model.py::test_split_is_neutralised` で検証していたのと同じ論点。
 *
 * 入力は**日付の昇順**である前提。出力も同じ順序で返す。
 * 出来高は価格と逆向きに調整する（分割で株数は増える）。
 */
export function applySplitAdjustment(rows: readonly PriceRow[]): PriceRow[] {
  const n = rows.length;
  const out: PriceRow[] = new Array(n);

  // 末尾から累積係数を作る。最新の足の係数は常に 1。
  let cumulative = 1;
  for (let i = n - 1; i >= 0; i -= 1) {
    const row = rows[i];
    if (row === undefined) continue;

    out[i] = {
      ...row,
      open: row.open * cumulative,
      high: row.high * cumulative,
      low: row.low * cumulative,
      close: row.close * cumulative,
      volume: cumulative === 0 ? row.volume : row.volume / cumulative,
    };

    // この足の factor は「この足より前」に効く。
    const f = row.adjustmentFactor;
    if (Number.isFinite(f) && f > 0) cumulative *= f;
  }
  return out;
}
