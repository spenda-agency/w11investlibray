import test from 'node:test';
import assert from 'node:assert/strict';
import { sma, ema, rsi, macd, atr, volumeRatio, rateOfChange, rollingExtreme } from '../.build/core.mjs';
import { WILDER_CLOSES, WILDER_RSI14_FIRST, naiveRsi, naiveSma, toBars, trendingCloses } from './fixtures.mjs';

test('sma — ウォームアップ区間は null、以降は算術平均', () => {
  const values = [1, 2, 3, 4, 5, 6];
  const out = sma(values, 3);
  assert.equal(out.length, values.length);
  assert.deepEqual(out.slice(0, 2), [null, null]);
  assert.equal(out[2], 2); // (1+2+3)/3
  assert.equal(out[5], 5); // (4+5+6)/3
});

test('sma — 入力より period が長ければ全て null', () => {
  assert.deepEqual(sma([1, 2], 5), [null, null]);
});

test('sma — 長い系列でも差分更新が素朴な実装からずれない', () => {
  // 差分更新（足して引く）は浮動小数の誤差が溜まる。組み直しが効いているか、
  // 毎回スライスして平均を取る素朴な実装と全点で突き合わせる。
  const values = Array.from({ length: 5000 }, (_, i) => 100 + Math.sin(i) * 10 + i * 0.01);
  const mine = sma(values, 25);
  const reference = naiveSma(values, 25);
  for (let i = 0; i < values.length; i += 1) {
    if (reference[i] === null) assert.equal(mine[i], null);
    else assert.ok(Math.abs(mine[i] - reference[i]) < 1e-9, `index ${i}: 差 ${Math.abs(mine[i] - reference[i])}`);
  }
});

test('ema — 先頭 period 本の単純平均で初期化する', () => {
  const values = [1, 2, 3, 4, 5];
  const out = ema(values, 3);
  assert.deepEqual(out.slice(0, 2), [null, null]);
  assert.equal(out[2], 2); // (1+2+3)/3
  const k = 2 / 4;
  assert.ok(Math.abs(out[3] - (4 * k + 2 * (1 - k))) < 1e-12);
});

test('rsi — 手計算したアンカーと一致する', () => {
  const out = rsi(WILDER_CLOSES, 14);
  assert.equal(out.length, WILDER_CLOSES.length);
  for (let i = 0; i < 14; i += 1) {
    assert.equal(out[i], null, `index ${i} はウォームアップ中`);
  }
  assert.ok(
    Math.abs(out[14] - WILDER_RSI14_FIRST) < 1e-4,
    `実測 ${out[14]} / 手計算 ${WILDER_RSI14_FIRST}`,
  );
});

test('rsi — 定義どおりの素朴な実装と系列全体が一致する', () => {
  // 本実装は逐次更新、参照実装は定義そのまま。別々に書いた 2 つが
  // 全点で一致すれば、片方だけの取り違えは残らない。
  for (const closes of [WILDER_CLOSES, trendingCloses(400, 7)]) {
    const mine = rsi(closes, 14);
    const reference = naiveRsi(closes, 14);
    assert.equal(mine.length, reference.length);
    for (let i = 0; i < mine.length; i += 1) {
      if (reference[i] === null) {
        assert.equal(mine[i], null, `index ${i} は両方 null であるべき`);
      } else {
        assert.ok(Math.abs(mine[i] - reference[i]) < 1e-9, `index ${i}: ${mine[i]} vs ${reference[i]}`);
      }
    }
  }
});

test('rsi — 一度も下落しない系列は 100', () => {
  const out = rsi([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16], 14);
  assert.equal(out[14], 100);
});

test('rsi — 一度も上昇しない系列は 0 に近づく', () => {
  const desc = Array.from({ length: 16 }, (_, i) => 100 - i);
  const out = rsi(desc, 14);
  assert.equal(out[14], 0);
});

test('macd — MACD が始まる位置からシグナル線を数える', () => {
  const closes = WILDER_CLOSES.concat(WILDER_CLOSES.map((c) => c + 2));
  const { macd: line, signal, histogram } = macd(closes, 12, 26, 9);

  // MACD は slow-1 = 25 から
  assert.equal(line[24], null);
  assert.ok(typeof line[25] === 'number');

  // シグナルは MACD が 9 本たまってから = 25 + 8 = 33
  assert.equal(signal[32], null);
  assert.ok(typeof signal[33] === 'number');

  // ヒストグラムは MACD - Signal
  assert.ok(Math.abs(histogram[33] - (line[33] - signal[33])) < 1e-12);
});

test('macd — null 区間を 0 として EMA に流し込んでいない', () => {
  // 一定値の系列では MACD は 0 に収束する。仮に null を 0 として扱っていると
  // シグナル線が別の初期値から始まり、ヒストグラムに偽の値が出る。
  const flat = new Array(60).fill(100);
  const { histogram } = macd(flat, 12, 26, 9);
  assert.ok(Math.abs(histogram[59]) < 1e-9, `平坦な系列でヒストグラムが ${histogram[59]}`);
});

test('macd — fast >= slow は拒否する', () => {
  assert.throws(() => macd([1, 2, 3], 26, 12, 9), RangeError);
});

test('atr — 前日終値をまたぐギャップを取り込む', () => {
  const bars = [
    { date: '2020-01-01', open: 100, high: 105, low: 95, close: 100, volume: 1 },
    // 前日終値 100 から窓を空けて上に飛ぶ。高安の幅より前日終値との差が大きい。
    { date: '2020-01-02', open: 120, high: 125, low: 118, close: 120, volume: 1 },
  ];
  const out = atr(bars, 2);
  // TR[0] = 10, TR[1] = max(7, |125-100|, |118-100|) = 25 → 平均 17.5
  assert.ok(Math.abs(out[1] - 17.5) < 1e-12, `実測 ${out[1]}`);
});

test('volumeRatio — 移動平均は当日を含む', () => {
  const volumes = new Array(20).fill(100).concat([200]);
  const out = volumeRatio(volumes, 20);
  assert.equal(out[19], 1);
  // index 20 の窓は index 1〜20。100 が 19 本と 200 が 1 本で平均 105。
  // 当日を含めるぶん比率は少し小さく出る。docs/SCORING.md の定義に合わせている。
  assert.ok(Math.abs(out[20] - 200 / 105) < 1e-12, `実測 ${out[20]}`);
});

test('volumeRatio — 平均が 0 なら null（ゼロ除算を返さない）', () => {
  const out = volumeRatio(new Array(21).fill(0), 20);
  assert.equal(out[20], null);
});

test('rateOfChange — n 本前からの騰落率', () => {
  const out = rateOfChange([100, 0, 0, 0, 0, 110], 5);
  assert.ok(Math.abs(out[5] - 0.1) < 1e-12);
});

test('rollingExtreme — 単調デックが素朴な計算と一致する', () => {
  const values = Array.from({ length: 400 }, (_, i) => Math.sin(i / 7) * 100 + i);
  for (const kind of ['high', 'low']) {
    const fast = rollingExtreme(values, 250, kind);
    for (const i of [0, 1, 100, 249, 250, 399]) {
      const window = values.slice(Math.max(0, i - 249), i + 1);
      const naive = kind === 'high' ? Math.max(...window) : Math.min(...window);
      assert.ok(Math.abs(fast[i] - naive) < 1e-12, `${kind} index ${i}`);
    }
  }
});

test('rollingExtreme — 期間に満たなくても、あるだけで計算する', () => {
  // 上場から日が浅い銘柄を一律に除外すると、新規上場が候補に出てこなくなる。
  const out = rollingExtreme([10, 20, 5], 250, 'high');
  assert.deepEqual([...out], [10, 20, 20]);
});

test('指標は入力と同じ長さを返す', () => {
  const closes = WILDER_CLOSES;
  const bars = toBars(closes);
  for (const out of [sma(closes, 5), ema(closes, 5), rsi(closes, 14), atr(bars, 14)]) {
    assert.equal(out.length, closes.length);
  }
});
