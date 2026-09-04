import test from 'node:test';
import assert from 'node:assert/strict';
import { JquantsClient, JquantsJpSource, JquantsError, parseAliases } from '../.build/worker.mjs';

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
    c.requireNumber({ Weird: 1 }, 'close', '/prices/daily_quotes');
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
  const impl = fakeFetch([
    { daily_quotes: [{ Code: '13010', Close: 100 }], pagination_key: 'p2' },
    { daily_quotes: [{ Code: '13320', Close: 200 }] },
  ]);
  const c = new JquantsClient('k', { fetchImpl: impl, baseUrl: 'https://x.test/v2' });
  const rows = await c.getAll('/prices/daily_quotes', { date: '2026-08-27' }, 'daily_quotes');
  assert.equal(rows.length, 2);
  assert.match(impl.calls[1], /pagination_key=p2/);
});

test('HTTP エラーは状態コードを含めて投げる', async () => {
  const impl = async () => new Response('forbidden', { status: 403 });
  const c = new JquantsClient('k', { fetchImpl: impl });
  await assert.rejects(
    () => c.getAll('/prices/daily_quotes', {}, 'daily_quotes'),
    (err) => err instanceof JquantsError && err.status === 403,
  );
});

test('日足 — 売買不成立の銘柄は行を作らない', async () => {
  const impl = fakeFetch([
    {
      daily_quotes: [
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

test('営業日カレンダー — 半日立会（区分 2）も営業日として扱う', async () => {
  const impl = fakeFetch([
    {
      trading_calendar: [
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
    { info: [{ Code: '72030', CompanyName: 'トヨタ自動車', Sector33CodeName: '輸送用機器' }] },
  ]);
  const source = new JquantsJpSource(new JquantsClient('k', { fetchImpl: impl }));
  const symbols = await source.listSymbols('2026-08-27');
  assert.equal(symbols[0].symbolId, 'JP.72030');
  assert.equal(symbols[0].name, 'トヨタ自動車');
  assert.equal(symbols[0].currency, 'JPY');
});

test('別名設定の JSON が壊れていてもパイプラインを止めない', () => {
  assert.deepEqual(parseAliases('{ broken'), {});
  assert.deepEqual(parseAliases(''), {});
  assert.deepEqual(parseAliases(undefined), {});
  assert.deepEqual(parseAliases('{"close":["X"]}'), { close: ['X'] });
});
