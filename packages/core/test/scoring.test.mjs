import test from 'node:test';
import assert from 'node:assert/strict';
import {
  computeScore,
  computeLevels,
  normalise,
  COMPONENT_MAX,
  SCORE_VERSION_TECHNICAL,
  SCORE_VERSION_FULL,
} from '../.build/core.mjs';

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
    volRatio: 1.6,
    ret20: 0.05,
    ret60: 0.1,
    hi52: 105,
    lo52: 80,
    ...overrides,
  };
}

test('配点の合計は 100', () => {
  const sum = Object.values(COMPONENT_MAX).reduce((a, b) => a + b, 0);
  assert.equal(sum, 100);
});

test('理想的な条件では総合点が満点に近づく', () => {
  const r = computeScore(snap());
  assert.equal(r.components.trend, 20);
  assert.equal(r.components.macd, 15);
  assert.equal(r.components.ma, 15);
  assert.equal(r.components.volume, 10);
  assert.equal(r.components.rsi, 10);
  assert.equal(r.components.momentum, 10);
  // テクニカル 80/80 → 100 に正規化される
  assert.equal(r.total, 100);
});

test('欠損項目は 0 点ではなく分母から外れる', () => {
  // ニュースが無い銘柄と、悪材料がある銘柄を同じ扱いにしてはいけない。
  const withoutNews = normalise({
    trend: 20, rsi: 10, macd: 15, ma: 15, volume: 10, momentum: 10,
    fundamental: null, news: null,
  });
  assert.equal(withoutNews, 100, '埋まっている 80 点満点で正規化する');

  const withZeroNews = normalise({
    trend: 20, rsi: 10, macd: 15, ma: 15, volume: 10, momentum: 10,
    fundamental: 0, news: 0,
  });
  assert.equal(withZeroNews, 80, '0 点が入っていれば分母に含まれる');
  assert.notEqual(withoutNews, withZeroNews);
});

test('全項目が null なら total も null', () => {
  assert.equal(
    normalise({ trend: null, rsi: null, macd: null, ma: null, volume: null, momentum: null, fundamental: null, news: null }),
    null,
  );
});

test('score_version はファンダ / ニュースの有無で決まる', () => {
  assert.equal(computeScore(snap()).scoreVersion, SCORE_VERSION_TECHNICAL);
  assert.equal(
    computeScore(snap(), { fundamental: 8, news: 7 }).scoreVersion,
    SCORE_VERSION_FULL,
  );
});

test('RSI — 買われすぎは減点する（高いほど良いではない）', () => {
  const band = computeScore(snap({ rsi14: 55 })).components.rsi;
  const high = computeScore(snap({ rsi14: 85 })).components.rsi;
  const low = computeScore(snap({ rsi14: 25 })).components.rsi;
  assert.equal(band, 10);
  assert.ok(high < band, `買われすぎ ${high} は最適帯 ${band} より低い`);
  assert.ok(low < band);
});

test('出来高 — 3 倍超は満点にしない', () => {
  const normal = computeScore(snap({ volRatio: 1.6 })).components.volume;
  const spike = computeScore(snap({ volRatio: 5.0 })).components.volume;
  assert.equal(normal, 10);
  assert.ok(spike < normal, `急増 ${spike} は 1.5〜3.0 倍 ${normal} より低い`);
});

test('ウォームアップ中の銘柄は該当項目が null になる', () => {
  const young = snap({ sma200: null, sma75: null, sma75Prev: null, ret60: null });
  const r = computeScore(young);
  assert.equal(r.components.ma, null, 'SMA200 が無ければ移動平均項目は評価しない');
  assert.equal(r.components.trend, null, 'SMA75 が無ければトレンド項目は評価しない');
  assert.equal(r.components.momentum, null);
  assert.ok(r.total !== null, '評価できる項目だけで総合点は出る');
});

test('verdict — 下降トレンドは総合点に関わらず AVOID', () => {
  const down = snap({ close: 90, sma75: 100, sma25: 95, sma25Prev: 97 });
  assert.equal(computeScore(down).verdict, 'AVOID');
});

test('verdict — 高得点でも買われすぎなら BUY_NOW にしない', () => {
  const overbought = computeScore(snap({ rsi14: 72 }));
  assert.notEqual(overbought.verdict, 'BUY_NOW');
});

test('verdict — 高得点でも出来高が細っていれば BUY_NOW にしない', () => {
  const thin = computeScore(snap({ volRatio: 0.6 }));
  assert.notEqual(thin.verdict, 'BUY_NOW');
});

test('verdict — 条件が揃えば BUY_NOW', () => {
  assert.equal(computeScore(snap()).verdict, 'BUY_NOW');
});

test('verdict — 4 値のいずれかを必ず返す', () => {
  const allowed = new Set(['BUY_NOW', 'BUY_WATCH', 'WATCH', 'AVOID']);
  for (const rsi14 of [null, 10, 35, 50, 68, 85]) {
    for (const volRatio of [null, 0.3, 1.0, 4.0]) {
      const v = computeScore(snap({ rsi14, volRatio })).verdict;
      assert.ok(allowed.has(v), `想定外の verdict: ${v}`);
    }
  }
});

test('損切り / 利確 — ATR から機械的に決まり、リスクリワードは 1.5 になる', () => {
  // ATR 3、終値 100。25日線 99 は 100-2*3=94 より上なので ATR 側が採用される。
  const lv = computeLevels(snap({ sma25: 90 }));
  assert.ok(Math.abs(lv.stop - 94) < 1e-9, `stop ${lv.stop}`);
  assert.ok(Math.abs(lv.target - 109) < 1e-9, `target ${lv.target}`);
  assert.ok(Math.abs(lv.rr - 1.5) < 1e-9, `rr ${lv.rr}`);
});

test('損切り — 25日線が ATR 幅より上なら 25日線のすぐ下を使う', () => {
  // 25日線 99 > 100-2*3=94 なので、25日線割れで切る
  const lv = computeLevels(snap({ sma25: 99 }));
  assert.ok(Math.abs(lv.stop - 99 * 0.99) < 1e-9, `stop ${lv.stop}`);
  assert.ok(lv.stop > 94, '25日線割れのほうが浅い損切りになる');
});

test('損切り — ATR が無ければ水準を出さない（推測で埋めない）', () => {
  const lv = computeLevels(snap({ atr14: null }));
  assert.equal(lv.stop, null);
  assert.equal(lv.target, null);
  assert.equal(lv.rr, null);
  assert.equal(lv.entry, 100);
});
