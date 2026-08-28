import test from 'node:test';
import assert from 'node:assert/strict';
import {
  detectGoldenCross,
  detectExitSignals,
  computeSnapshots,
  QUALIFIED_STRENGTH,
} from '../.build/core.mjs';
import { toBars, trendingCloses } from './fixtures.mjs';

/** 条件を明示的に指定して snapshot を作る（指標計算を経由せずに判定だけ見る）。 */
function snap(overrides = {}) {
  return {
    close: 100,
    rsi14: 55,
    macd: 1,
    macdSignal: 0.5,
    macdHist: 0.5,
    macdHistPrev: 0.3,
    sma5: 101,
    sma25: 99,
    sma75: 95,
    sma200: 90,
    sma5Prev: 100,
    sma25Prev: 98,
    sma75Prev: 94,
    atr14: 3,
    volSma20: 1000,
    volRatio: 1.4,
    ret20: 0.05,
    ret60: 0.1,
    hi52: 105,
    lo52: 80,
    ...overrides,
  };
}

test('ゴールデンクロス — 8 条件すべて揃えば strength は 8', () => {
  const gc = detectGoldenCross(snap(), snap({ sma5: 98, sma25: 99 }));
  assert.equal(gc.strength, 8);
  assert.equal(gc.crossedToday, true);
  assert.equal(gc.qualified, true);
});

test('ゴールデンクロス — 単純なクロスとトレンド転換を伴うクロスを区別する', () => {
  // 5日線が25日線を上抜けてはいるが、下降トレンドの中で起きている。
  const weak = snap({
    close: 90,
    sma25: 95,
    sma25Prev: 97, // 25日線は下向き
    sma75: 100,
    macd: -1,
    macdSignal: -0.5,
    macdHist: -0.5,
    rsi14: 42,
    volRatio: 0.7,
    sma5: 96,
  });
  const yesterday = snap({ sma5: 94, sma25: 95 });
  const gc = detectGoldenCross(weak, yesterday);

  assert.equal(gc.crossedToday, true, 'クロス自体は起きている');
  assert.ok(gc.strength < QUALIFIED_STRENGTH, `strength ${gc.strength}`);
  assert.equal(gc.qualified, false, '下降トレンド中のクロスは qualified にしない');
});

test('ゴールデンクロス — 既にクロス済みの日は crossedToday にならない', () => {
  // 昨日すでに 5日線 > 25日線 だった
  const gc = detectGoldenCross(snap(), snap({ sma5: 101, sma25: 99 }));
  assert.equal(gc.crossedToday, false);
  assert.equal(gc.qualified, false, 'クロス日でなければ qualified にしない');
});

test('ゴールデンクロス — 前日が無い（上場直後）なら crossedToday は false', () => {
  const gc = detectGoldenCross(snap(), null);
  assert.equal(gc.crossedToday, false);
  assert.equal(gc.qualified, false);
});

test('ゴールデンクロス — 買われすぎは rsi_in_band に入らない', () => {
  const gc = detectGoldenCross(snap({ rsi14: 78 }), snap({ sma5: 98, sma25: 99 }));
  assert.ok(!gc.met.includes('rsi_in_band'));
  assert.equal(gc.strength, 7);
});

test('ゴールデンクロス — 指標が null の条件は数えない', () => {
  const empty = snap({
    rsi14: null, macd: null, macdSignal: null, macdHist: null,
    sma5: null, sma25: null, sma75: null, volRatio: null,
  });
  const gc = detectGoldenCross(empty, null);
  assert.equal(gc.strength, 0);
  assert.deepEqual(gc.met, []);
});

test('手仕舞い — 買われすぎ / デッドクロス / 25日線割れを拾う', () => {
  const overbought = detectExitSignals(snap({ rsi14: 80 }), snap());
  assert.ok(overbought.met.includes('rsi_overbought'));
  assert.equal(overbought.triggered, true);

  const dead = detectExitSignals(
    snap({ macd: 0.2, macdSignal: 0.5 }),
    snap({ macd: 0.6, macdSignal: 0.5 }),
  );
  assert.ok(dead.met.includes('macd_dead_cross'));

  const below = detectExitSignals(snap({ close: 90, sma25: 99 }), snap());
  assert.ok(below.met.includes('below_sma25'));
});

test('手仕舞い — 条件が揃っていなければ triggered は false', () => {
  const healthy = detectExitSignals(snap(), snap({ macd: 0.9, macdSignal: 0.5 }));
  assert.equal(healthy.triggered, false, `met: ${healthy.met.join(',')}`);
});

test('実データ相当の系列でも strength は 0〜8 に収まる', () => {
  const snapshots = computeSnapshots(toBars(trendingCloses(400, 11)));
  for (let i = 1; i < snapshots.length; i += 1) {
    const gc = detectGoldenCross(snapshots[i], snapshots[i - 1]);
    assert.ok(gc.strength >= 0 && gc.strength <= 8, `index ${i}: ${gc.strength}`);
    assert.equal(gc.met.length, gc.strength);
  }
});
