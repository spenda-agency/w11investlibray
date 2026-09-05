import test from 'node:test';
import assert from 'node:assert/strict';
import { JquantsClient, JquantsJpSource, JquantsError, parseAliases, JP_PATHS } from '../.build/worker.mjs';

/** ページングを 2 ページ返す偽の fetch。 */
function fakeFetch(pages) {
  let call = 0;
  const calls = [];
  const impl = async (url) => {
    calls.push(url);
    const body = pages[Math.min(call, pages.length - 1)];
    call += 1;
    return new Response(JSON.stringify(body), { status: 200 });
  };
  impl.calls = calls;
  return impl;
}

test('項目名のゆらぎを正準名へ寄せる（長い名前）', () => {
  const c = new JquantsClient('k');
  const row = { Close: 1234, Code: '72030', Volume: 500 };
  assert.equal(c.requireNumber(row, 'close', 'test'), 1234);
  assert.equal(c.requireString(row, 'code', 'test'), '72030');
  assert.equal(c.optionalNumber(row, 'volume'), 500);
});

test('項目名のゆらぎを正準名へ寄せる（短縮名）', () => {
  // V2 で項目名が短縮された。どちらでも同じ正準名に解決できる必要がある。
  const c = new JquantsClient('k');
  const row = { C: 1234, Cd: '72030', V: 500 };
  assert.equal(c.requireNumber(row, 'close', 'test'), 1234);
  assert.equal(c.requireString(row, 'code', 'test'), '72030');
  assert.equal(c.optionalNumber(row, 'volume'), 500);
});

test('未知の項目名は設定で足せる（コードを直さずに復旧できる）', () => {
  const row = { ClosingPrice: 999 };
  const plain = new JquantsClient('k');
  assert.throws(() => plain.requireNumber(row, 'close', 'test'), JquantsError);

  const patched = new JquantsClient('k', { extraAliases: { close: ['ClosingPrice'] } });
  assert.equal(patched.requireNumber(row, 'close', 'test'), 999);
});

test('項目が見つからないエラーは、実際に来たキーを教える', () => {
  const c = new JquantsClient('k');
  try {
    c.requireNumber({ Weird: 1 }, 'close', '/equities/bars/daily');
    assert.fail('例外になるはず');
  } catch (err) {
    assert.match(err.message, /Weird/, '実際のキーを含める');
    assert.match(err.message, /JQUANTS_FIELD_ALIASES/, '直し方を示す');
  }
});

test('数値は文字列で返ってきても数値として扱う', () => {
  const c = new JquantsClient('k');
  assert.equal(c.requireNumber({ Close: '1234.5' }, 'close', 'test'), 1234.5);
  assert.equal(c.optionalNumber({ Close: 'N/A' }, 'close'), null);
});

test('APIキーが空ならクライアントを作れない', () => {
  assert.throws(() => new JquantsClient(''), JquantsError);
});

test('APIキーに ASCII 以外が混じっていたら、何が悪いかを言って止まる', () => {
  // **キーは HTTP ヘッダーに入る。** 全角が混じったまま fetch に渡すと
  // `Cannot convert argument to a ByteString because the character at
  // index 0 has a value of 65288` という、原因の分からないエラーになる。
  // 65288 は `（`——手順書のプレースホルダをそのまま貼ると踏む。実際に踏んだ。
  for (const bad of ['（同じキー）', 'abc def', 'abc\n', ' abc', 'キー']) {
    assert.throws(
      () => new JquantsClient(bad),
      (err) => err instanceof JquantsError && /使えない文字/.test(err.message),
      JSON.stringify(bad),
    );
  }

  // 本物のキーの形（英数と記号）は通る
  assert.doesNotThrow(() => new JquantsClient('eyJhbGciOiJIUzI1NiJ9.abc-_=+/'));
});

test('ページングを最後まで辿る', async () => {
  // **レコードは `data` に入る。** 経路ごとに違うキーだったのは V1。
  const impl = fakeFetch([
    { data: [{ Code: '13010', Close: 100 }], pagination_key: 'p2' },
    { data: [{ Code: '13320', Close: 200 }] },
  ]);
  const c = new JquantsClient('k', { fetchImpl: impl, baseUrl: 'https://x.test/v2' });
  const rows = await c.getAll(JP_PATHS.dailyBars, { date: '2026-08-27' });
  assert.equal(rows.length, 2);
  assert.match(impl.calls[1], /pagination_key=p2/);
});

test('HTTP エラーは状態コードを含めて投げる', async () => {
  const impl = async () => new Response('forbidden', { status: 403 });
  const c = new JquantsClient('k', { fetchImpl: impl });
  await assert.rejects(
    () => c.getAll(JP_PATHS.dailyBars, {}),
    (err) => err instanceof JquantsError && err.status === 403,
  );
});

test('日足 — 売買不成立の銘柄は行を作らない', async () => {
  const impl = fakeFetch([
    {
      data: [
        { Code: '13010', Open: 100, High: 110, Low: 95, Close: 105, Volume: 1000, AdjustmentFactor: 1 },
        { Code: '99990', Open: null, High: null, Low: null, Close: null, Volume: 0 },
      ],
    },
  ]);
  const source = new JquantsJpSource(new JquantsClient('k', { fetchImpl: impl }));
  const bars = await source.fetchDailyBars('2026-08-27');
  assert.equal(bars.length, 1);
  assert.equal(bars[0].symbolId, 'JP.13010');
  assert.equal(bars[0].close, 105);
  assert.equal(bars[0].adjustmentFactor, 1);
});

test('日足 — V2 の短縮名でも読める', async () => {
  // 参照実装（w09jquantsclaude の schema.py）が受け付けている形。
  // TurnoverValue → Va、AdjustmentFactor → AdjFactor は、こちらの推測と
  // ずれていた（TuVa / AdjFa と書いていた）。実物に合わせてある。
  const impl = fakeFetch([
    { data: [{ Cd: '13010', O: 100, H: 110, L: 95, C: 105, Vo: 1000, Va: 52500, AdjFactor: 1 }] },
  ]);
  const source = new JquantsJpSource(new JquantsClient('k', { fetchImpl: impl }));
  const bars = await source.fetchDailyBars('2026-08-27');
  assert.equal(bars.length, 1);
  assert.equal(bars[0].close, 105);
  assert.equal(bars[0].volume, 1000);
  assert.equal(bars[0].turnover, 52500, 'TurnoverValue の短縮名 Va を読めていない');
  assert.equal(bars[0].adjustmentFactor, 1, 'AdjustmentFactor の短縮名 AdjFactor を読めていない');
});

test('営業日カレンダー — 半日立会（区分 2）も営業日として扱う', async () => {
  const impl = fakeFetch([
    {
      data: [
        { Date: '2026-01-01', HolidayDivision: '0' },
        { Date: '2026-01-05', HolidayDivision: '1' },
        { Date: '2026-01-06', HolidayDivision: '2' },
      ],
    },
  ]);
  const source = new JquantsJpSource(new JquantsClient('k', { fetchImpl: impl }));
  const cal = await source.tradingCalendar('2026-01-01', '2026-01-07');
  assert.deepEqual(cal.map((c) => c.isOpen), [false, true, true]);
});

test('銘柄一覧 — symbol_id に市場の名前空間が付く', async () => {
  const impl = fakeFetch([
    { data: [{ Code: '72030', CompanyName: 'トヨタ自動車', Sector33CodeName: '輸送用機器' }] },
  ]);
  const source = new JquantsJpSource(new JquantsClient('k', { fetchImpl: impl }));
  const symbols = await source.listSymbols('2026-08-27');
  assert.equal(symbols[0].symbolId, 'JP.72030');
  assert.equal(symbols[0].name, 'トヨタ自動車');
  assert.equal(symbols[0].currency, 'JPY');
});

// ---- 実物の形（2026-09-05 に check:datasource が返したキーそのもの）------------
//
// **ここが再発防止の本体。** これまでの擬似応答は「実装に合わせて」書いていたので、
// 経路名が V1 のままでも、別名表が実物とずれていても、全部通っていた。
// 以下は API が実際に返したキーの並びをそのまま貼ってある。
// 触るときは check:datasource の出力で確かめること。

test('実物 — /equities/master のキーから銘柄が読める', async () => {
  // 実際の並び: Date, Code, CoName, CoNameEn, S17, S17Nm, S33, S33Nm,
  //             ScaleCat, Mkt, MktNm, Mrgn, MrgnNm, ProdCat
  const impl = fakeFetch([
    {
      data: [
        {
          Date: '2026-09-02', Code: '72030', CoName: 'トヨタ自動車', CoNameEn: 'TOYOTA',
          S17: '6', S17Nm: '自動車・輸送機', S33: '3700', S33Nm: '輸送用機器',
          ScaleCat: 'TOPIX Core30', Mkt: '0111', MktNm: 'プライム',
          Mrgn: '1', MrgnNm: '信用', ProdCat: '1',
        },
      ],
    },
  ]);
  const source = new JquantsJpSource(new JquantsClient('k', { fetchImpl: impl }));
  const [sym] = await source.listSymbols('2026-09-02');
  assert.equal(sym.symbolId, 'JP.72030');
  assert.equal(sym.name, 'トヨタ自動車', 'CoName を読めていない');
  assert.equal(sym.sector33, '輸送用機器', 'S33Nm を読めていない — 業種フィルタが空振りする');
  assert.equal(sym.sector17, '自動車・輸送機', 'S17Nm を読めていない');
});

test('実物 — /markets/calendar の HolDiv で休場を判定する', async () => {
  // 実際の並び: Date, HolDiv
  //
  // **ここが当たらないと、静かに全日が営業日になる。**
  // optionalString だった頃は null !== '0' が true になり、
  // 祝日を営業日として保存していた。例外も警告も出なかった。
  const impl = fakeFetch([
    {
      data: [
        { Date: '2026-01-01', HolDiv: '0' },
        { Date: '2026-01-05', HolDiv: '1' },
        { Date: '2026-01-06', HolDiv: '2' },
      ],
    },
  ]);
  const source = new JquantsJpSource(new JquantsClient('k', { fetchImpl: impl }));
  const cal = await source.tradingCalendar('2026-01-01', '2026-01-07');
  assert.deepEqual(cal.map((c) => c.isOpen), [false, true, true]);
});

test('実物 — 営業日区分が読めなければ止まる（黙って営業日にしない）', async () => {
  const impl = fakeFetch([{ data: [{ Date: '2026-01-01', UnknownDivision: '0' }] }]);
  const source = new JquantsJpSource(new JquantsClient('k', { fetchImpl: impl }));
  await assert.rejects(
    () => source.tradingCalendar('2026-01-01', '2026-01-07'),
    (err) => err instanceof JquantsError && /UnknownDivision/.test(err.message),
    '読めない区分を黙って営業日として通している',
  );
});

test('実物 — /equities/bars/daily は余計な項目があっても読める', async () => {
  // 実際の並び: Date, Code, O, H, L, C, UL, LL, Vo, Va, AdjFactor,
  //             AdjO, AdjH, AdjL, AdjC, AdjVo, MktCap, ExRT
  //
  // **調整済みの値（AdjO…AdjVo）は使わない。** 生値 + AdjFactor を
  // @invest/core が調整する設計で、バックテストと本番で同じ計算を通している。
  const impl = fakeFetch([
    {
      data: [
        {
          Date: '2026-09-02', Code: '72030', O: 3000, H: 3100, L: 2950, C: 3050,
          UL: 3500, LL: 2500, Vo: 12000, Va: 36600000, AdjFactor: 1,
          AdjO: 3000, AdjH: 3100, AdjL: 2950, AdjC: 3050, AdjVo: 12000,
          MktCap: 45000000000000, ExRT: 0,
        },
      ],
    },
  ]);
  const source = new JquantsJpSource(new JquantsClient('k', { fetchImpl: impl }));
  const [bar] = await source.fetchDailyBars('2026-09-02');
  assert.equal(bar.symbolId, 'JP.72030');
  assert.equal(bar.open, 3000);
  assert.equal(bar.close, 3050);
  assert.equal(bar.volume, 12000);
  assert.equal(bar.turnover, 36600000);
  assert.equal(bar.adjustmentFactor, 1);
});

test('別名設定の JSON が壊れていてもパイプラインを止めない', () => {
  assert.deepEqual(parseAliases('{ broken'), {});
  assert.deepEqual(parseAliases(''), {});
  assert.deepEqual(parseAliases(undefined), {});
  assert.deepEqual(parseAliases('{"close":["X"]}'), { close: ['X'] });
});
