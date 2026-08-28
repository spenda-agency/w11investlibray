import test from 'node:test';
import assert from 'node:assert/strict';
import {
  runBacktest,
  assertExecutionBar,
  summarise,
  maxDrawdown,
  goldenCrossRule,
} from '../.build/core.mjs';
import { toBars, trendingCloses } from './fixtures.mjs';

/** 常に入る / 常に出ない、検証用の単純なルール。 */
function alwaysEnterRule(overrides = {}) {
  return {
    id: 'always-enter',
    shouldEnter: () => true,
    shouldExit: () => false,
    levels: () => ({ stop: null, target: null }),
    ...overrides,
  };
}

test('未来を参照しようとすると例外になる', () => {
  // これがこのエンジンの存在理由。「その日の終値を見て、その日の寄り付きで
  // 買っていたら」を計算できてしまうと、成績がまるごと嘘になる。
  const bars = toBars(trendingCloses(120, 3));
  const peeking = alwaysEnterRule({
    id: 'peeking',
    shouldEnter(ctx) {
      return ctx.history.at(ctx.index + 1).close > ctx.bar.close; // 明日を見る
    },
  });
  assert.throws(
    () => runBacktest('JP.0001', bars, peeking),
    /未来を参照しようとした/,
  );
});

test('当日までの参照は許される', () => {
  const bars = toBars(trendingCloses(120, 4));
  const lawful = alwaysEnterRule({
    id: 'lawful',
    shouldEnter(ctx) {
      return ctx.index > 0 && ctx.history.at(ctx.index).close > ctx.history.at(ctx.index - 1).close;
    },
  });
  assert.doesNotThrow(() => runBacktest('JP.0001', bars, lawful));
});

test('約定バーは判断バーより後でなければならない', () => {
  assert.throws(() => assertExecutionBar(5, 5), /同じ足かそれ以前では約定できない/);
  assert.throws(() => assertExecutionBar(5, 4), /同じ足かそれ以前では約定できない/);
  assert.doesNotThrow(() => assertExecutionBar(5, 6));
});

test('約定は判断した翌日の始値で行われる', () => {
  const bars = [
    { date: '2024-01-01', open: 100, high: 101, low: 99, close: 100, volume: 1 },
    { date: '2024-01-02', open: 110, high: 115, low: 109, close: 112, volume: 1 },
    { date: '2024-01-03', open: 120, high: 121, low: 119, close: 120, volume: 1 },
  ];
  // 初日に判断 → 2 日目の「始値 110」で約定する。2 日目の終値 112 ではない。
  const result = runBacktest('JP.0001', bars, alwaysEnterRule(), { costPerSide: 0 });
  const trade = result.trades[0];
  assert.equal(trade.entryDate, '2024-01-02');
  assert.equal(trade.entryPx, 110);
});

test('手数料は往復ぶん差し引かれる', () => {
  const bars = [
    { date: '2024-01-01', open: 100, high: 101, low: 99, close: 100, volume: 1 },
    { date: '2024-01-02', open: 100, high: 101, low: 99, close: 100, volume: 1 },
  ];
  const free = runBacktest('JP.0001', bars, alwaysEnterRule(), { costPerSide: 0 });
  const costly = runBacktest('JP.0001', bars, alwaysEnterRule(), { costPerSide: 0.01 });
  assert.ok(costly.trades[0].pnlPct < free.trades[0].pnlPct, 'コストぶん成績は下がる');
});

test('損切りと利確が同じ足で当たったら損切りを優先する', () => {
  // 日足では、どちらが先に当たったか分からない。成績を良く見せない側に倒す。
  const bars = [
    { date: '2024-01-01', open: 100, high: 100, low: 100, close: 100, volume: 1 },
    { date: '2024-01-02', open: 100, high: 100, low: 100, close: 100, volume: 1 },
    // 高値も安値も両方の水準に当たる足
    { date: '2024-01-03', open: 100, high: 130, low: 80, close: 100, volume: 1 },
  ];
  const rule = alwaysEnterRule({
    id: 'both-hit',
    levels: () => ({ stop: 90, target: 120 }),
  });
  const result = runBacktest('JP.0001', bars, rule, { costPerSide: 0 });
  assert.equal(result.trades[0].exitReason, 'stop');
});

test('最長保有日数を超えたら手仕舞う', () => {
  const bars = toBars(new Array(60).fill(100));
  const result = runBacktest('JP.0001', bars, alwaysEnterRule(), {
    costPerSide: 0,
    maxHoldBars: 5,
  });
  assert.ok(result.trades.length > 0);
  assert.ok(result.trades[0].barsHeld <= 7, `barsHeld ${result.trades[0].barsHeld}`);
});

test('データの終端で持ち越していたら最終終値で閉じる', () => {
  const bars = toBars(trendingCloses(100, 5));
  const result = runBacktest('JP.0001', bars, alwaysEnterRule(), { costPerSide: 0 });
  const last = result.trades[result.trades.length - 1];
  assert.equal(last.exitReason, 'end_of_data');
  assert.equal(last.exitDate, bars[bars.length - 1].date);
});

test('本番と同じルールがバックテストで動く', () => {
  // goldenCrossRule は detectGoldenCross / computeLevels をそのまま呼んでいる。
  // ここで別実装を書いていないことが、バックテストの意味を担保する。
  const bars = toBars(trendingCloses(600, 9));
  const result = runBacktest('JP.7203', bars, goldenCrossRule);
  assert.equal(result.ruleId, 'golden-cross-v1');
  assert.equal(result.equity.length, bars.length);
  for (const t of result.trades) {
    assert.ok(t.entryDate < t.exitDate, `${t.entryDate} → ${t.exitDate}`);
    assert.ok(Number.isFinite(t.pnlPct));
  }
});

test('統計 — 勝率・プロフィットファクター・期待値', () => {
  const trades = [
    { symbolId: 'X', entryDate: 'a', entryPx: 100, exitDate: 'b', exitPx: 110, pnlPct: 0.1, exitReason: 'target', barsHeld: 5 },
    { symbolId: 'X', entryDate: 'c', entryPx: 100, exitDate: 'd', exitPx: 95, pnlPct: -0.05, exitReason: 'stop', barsHeld: 3 },
    { symbolId: 'X', entryDate: 'e', entryPx: 100, exitDate: 'f', exitPx: 120, pnlPct: 0.2, exitReason: 'target', barsHeld: 8 },
  ];
  const s = summarise(trades, []);
  assert.equal(s.trades, 3);
  assert.ok(Math.abs(s.winRate - 2 / 3) < 1e-12);
  assert.ok(Math.abs(s.avgWin - 0.15) < 1e-12);
  assert.ok(Math.abs(s.avgLoss - -0.05) < 1e-12);
  assert.ok(Math.abs(s.profitFactor - 0.3 / 0.05) < 1e-9);
  assert.ok(Math.abs(s.expectancy - 0.25 / 3) < 1e-12);
});

test('統計 — 取引が無ければ null を返す（0 と区別する）', () => {
  const s = summarise([], []);
  assert.equal(s.trades, 0);
  assert.equal(s.winRate, null);
  assert.equal(s.profitFactor, null);
});

test('最大ドローダウン — 山からの下落率', () => {
  const equity = [1.0, 1.2, 0.9, 1.1].map((e, i) => ({ date: `d${i}`, equity: e, ret: 0 }));
  // 山 1.2 から 0.9 → -25%
  assert.ok(Math.abs(maxDrawdown(equity) - -0.25) < 1e-12);
});

test('エクイティ曲線は足の数と一致する', () => {
  const bars = toBars(trendingCloses(200, 13));
  const result = runBacktest('JP.0001', bars, goldenCrossRule);
  assert.equal(result.equity.length, bars.length);
  assert.equal(result.equity[0].date, bars[0].date);
});
