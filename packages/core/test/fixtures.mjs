/**
 * テスト用の固定データと、独立した参照実装。
 *
 * **公表値を記憶から書き写さないこと。** 期待値を思い出しで置くと、
 * 実装が正しくてもテストが落ちる（実際にこれをやって 70.46 と書き、
 * 正しい 70.5328 に対して失敗した）。
 *
 * ここでは代わりに 2 つの方法で確かめる。
 *   1. 手計算で検証した値をアンカーとして 1 点だけ置く
 *   2. 定義そのままの素朴な実装（`naiveRsi`）と系列全体を突き合わせる
 * 素朴な実装は最適化を一切していないので、最適化した本実装のバグが
 * 同じ形で混入することがない。
 */
export const WILDER_CLOSES = [
  44.3389, 44.0902, 44.1497, 43.6124, 44.3278, 44.8264, 45.0955, 45.4245,
  45.8433, 46.0826, 45.8931, 46.0328, 45.614, 46.282, 46.282, 46.0033,
  46.0328, 46.4116, 46.2222, 45.6439, 46.2122, 46.2521, 45.7137, 46.4515,
  45.7835, 45.3548, 44.0288, 44.1783, 44.2181, 44.5672, 43.4205, 42.6628,
  43.1314,
];

/**
 * 上の系列の RSI(14) の最初の値。**手計算で検証したアンカー。**
 *
 *   index 1〜14 の変化量  上昇の合計 3.3374 / 下落の合計 1.3943
 *   avgGain = 3.3374/14 = 0.2383857
 *   avgLoss = 1.3943/14 = 0.0995929
 *   RS      = 2.393603
 *   RSI     = 100 - 100/(1+RS) = 70.5328
 */
export const WILDER_RSI14_FIRST = 70.5328;

/**
 * Wilder の RSI を定義そのままに書いたもの。速度も再利用も考えていない。
 * 本実装との突き合わせ専用。
 */
export function naiveRsi(closes, period) {
  const out = new Array(closes.length).fill(null);
  if (closes.length <= period) return out;

  const deltas = [];
  for (let i = 1; i < closes.length; i += 1) deltas.push(closes[i] - closes[i - 1]);

  const gains = deltas.map((d) => (d > 0 ? d : 0));
  const losses = deltas.map((d) => (d < 0 ? -d : 0));

  const mean = (arr) => arr.reduce((a, b) => a + b, 0) / arr.length;
  let avgGain = mean(gains.slice(0, period));
  let avgLoss = mean(losses.slice(0, period));
  out[period] = avgLoss === 0 ? (avgGain === 0 ? 50 : 100) : 100 - 100 / (1 + avgGain / avgLoss);

  for (let i = period; i < deltas.length; i += 1) {
    avgGain = (avgGain * (period - 1) + gains[i]) / period;
    avgLoss = (avgLoss * (period - 1) + losses[i]) / period;
    out[i + 1] = avgLoss === 0 ? (avgGain === 0 ? 50 : 100) : 100 - 100 / (1 + avgGain / avgLoss);
  }
  return out;
}

/** 単純移動平均の素朴な実装。本実装は差分更新なので、そこと突き合わせる。 */
export function naiveSma(values, period) {
  const out = new Array(values.length).fill(null);
  for (let i = period - 1; i < values.length; i += 1) {
    out[i] = values.slice(i - period + 1, i + 1).reduce((a, b) => a + b, 0) / period;
  }
  return out;
}

/** 足を組み立てる。指標のテストでは高安に幅を持たせておく。 */
export function toBars(closes, { startDate = '2020-01-01', volume = 1000 } = {}) {
  const base = new Date(`${startDate}T00:00:00Z`);
  return closes.map((close, i) => {
    const d = new Date(base.getTime() + i * 86400000);
    const date = d.toISOString().slice(0, 10);
    return {
      date,
      open: close,
      high: close * 1.01,
      low: close * 0.99,
      close,
      volume: typeof volume === 'function' ? volume(i) : volume,
    };
  });
}

/** 決定論的な擬似乱数（テストを再現可能にするため）。 */
export function lcg(seed) {
  let s = seed >>> 0;
  return () => {
    s = (Math.imul(s, 1664525) + 1013904223) >>> 0;
    return s / 0x100000000;
  };
}

/** 上昇トレンドののち下降に転じる、ゴールデンクロス検証用の系列。 */
export function trendingCloses(n = 300, seed = 42) {
  const rand = lcg(seed);
  const out = [];
  let price = 1000;
  for (let i = 0; i < n; i += 1) {
    const drift = i < n * 0.6 ? 1.5 : -1.2;
    price += drift + (rand() - 0.5) * 6;
    out.push(Math.max(1, price));
  }
  return out;
}
