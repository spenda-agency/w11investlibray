import test from 'node:test';
import assert from 'node:assert/strict';
import {
  applySplitAdjustment,
  toSymbolId,
  parseSymbolId,
  toJquantsCode,
  toDisplayCode,
  chunk,
  computeSnapshots,
} from '../.build/core.mjs';

function priceRow(date, close, adjustmentFactor = 1, volume = 500) {
  return {
    symbolId: 'JP.72030',
    date,
    open: close,
    high: close,
    low: close,
    close,
    volume,
    adjustmentFactor,
  };
}

/** 1:2 分割をまたぐ系列。分割前は 200 円 / 500 株、分割後は 100 円 / 1000 株。 */
function splitSeries() {
  const rows = [];
  for (let i = 0; i < 40; i += 1) {
    rows.push(priceRow(`2024-01-${String(i + 1).padStart(2, '0')}`, 200, 1, 500));
  }
  // 権利落ち日。この足は既に分割後の価格で、factor はこれ以前に効く。
  rows.push(priceRow('2024-03-01', 100, 0.5, 1000));
  for (let i = 0; i < 40; i += 1) {
    rows.push(priceRow(`2024-04-${String(i + 1).padStart(2, '0')}`, 100, 1, 1000));
  }
  return rows;
}

test('株式分割 — 調整後の価格系列が連続する', () => {
  // ここを間違えると、分割日をまたいだ瞬間に移動平均とゴールデンクロスが
  // 一斉に誤爆する。
  const adjusted = applySplitAdjustment(splitSeries());
  for (const row of adjusted) {
    assert.ok(Math.abs(row.close - 100) < 1e-9, `${row.date}: ${row.close}`);
  }
});

test('株式分割 — 出来高は価格と逆向きに調整される', () => {
  const adjusted = applySplitAdjustment(splitSeries());
  for (const row of adjusted) {
    assert.ok(Math.abs(row.volume - 1000) < 1e-9, `${row.date}: ${row.volume}`);
  }
});

test('株式分割 — 調整しないと指標が飛ぶ', () => {
  const raw = splitSeries();
  const adjusted = applySplitAdjustment(raw);

  const rawSma = computeSnapshots(raw).map((s) => s.sma25);
  const adjSma = computeSnapshots(adjusted).map((s) => s.sma25);

  // 権利落ちの直後（index 41）では、未調整の 25 日線は 200 と 100 の混ざった値。
  assert.ok(rawSma[41] > 120, `未調整の 25日線が ${rawSma[41]}`);
  // 調整後は一貫して 100。
  assert.ok(Math.abs(adjSma[41] - 100) < 1e-9, `調整後の 25日線が ${adjSma[41]}`);
});

test('株式分割 — 最新の足は常に調整されない', () => {
  const rows = splitSeries();
  const adjusted = applySplitAdjustment(rows);
  const lastRaw = rows[rows.length - 1];
  const lastAdj = adjusted[adjusted.length - 1];
  assert.equal(lastAdj.close, lastRaw.close);
  assert.equal(lastAdj.volume, lastRaw.volume);
});

test('株式分割 — factor が 1 だけなら何も変わらない', () => {
  const rows = [priceRow('2024-01-01', 100), priceRow('2024-01-02', 105)];
  const adjusted = applySplitAdjustment(rows);
  assert.equal(adjusted[0].close, 100);
  assert.equal(adjusted[1].close, 105);
});

test('symbol_id — 市場ごとの名前空間を持つ', () => {
  assert.equal(toSymbolId('JP', '72030'), 'JP.72030');
  assert.equal(toSymbolId('US', 'nvda'), 'US.NVDA');
  assert.equal(toSymbolId('FX', 'usdjpy'), 'FX.USDJPY');
});

test('symbol_id — 往復して同じ値に戻る', () => {
  for (const [market, code] of [['JP', '72030'], ['US', 'AAPL'], ['FX', 'EURUSD']]) {
    const id = toSymbolId(market, code);
    const parsed = parseSymbolId(id);
    assert.equal(parsed.market, market);
    assert.equal(parsed.code, code);
  }
});

test('symbol_id — 不正な形式は拒否する', () => {
  assert.throws(() => parseSymbolId('7203'), RangeError);
  assert.throws(() => parseSymbolId('XX.7203'), RangeError);
  assert.throws(() => parseSymbolId('JP.'), RangeError);
  assert.throws(() => toSymbolId('JP', ''), RangeError);
  assert.throws(() => toSymbolId('JP', 'A.B'), RangeError);
});

test('日本株コード — 4 桁と 5 桁を相互に変換する', () => {
  assert.equal(toJquantsCode('7203'), '72030');
  assert.equal(toJquantsCode('72030'), '72030', '既に 5 桁なら何もしない');
  assert.equal(toDisplayCode('72030'), '7203');
  assert.equal(toDisplayCode('130A0'), '130A', '英字を含むコードも 4 桁へ戻す');
});

test('日本株コード — 末尾が 0 でない 5 桁はそのまま', () => {
  assert.equal(toDisplayCode('12345'), '12345');
});

test('chunk — 端数を含めて全件が残る', () => {
  const items = Array.from({ length: 503 }, (_, i) => i);
  const batches = chunk(items, 100);
  assert.equal(batches.length, 6);
  assert.equal(batches[5].length, 3);
  assert.equal(batches.flat().length, 503);
});

test('chunk — size が不正なら拒否する', () => {
  assert.throws(() => chunk([1, 2], 0), RangeError);
});
