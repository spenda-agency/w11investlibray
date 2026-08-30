import { writeFile, mkdir } from 'node:fs/promises';
import { dirname } from 'node:path';
import { toSymbolId } from '@invest/core';
import { Jquants, sleep } from '../jquants.js';
import { insertStatements } from '../sql.js';

/**
 * 過去の日足をまとめて取得し、D1 へ流し込む .sql を書き出す。
 *
 * **これを Worker でやらない理由**は 2 つ。
 *   1. 500 銘柄 × 10 年 ≒ 122 万行。D1 の無料枠（10 万行/日）では 2 週間かかる
 *   2. 取得だけで約 2,450 リクエスト。Worker の実行時間に収まらない
 * GitHub Actions で回して結果だけ流し込むほうが速く、途中で失敗しても
 * 日付を指定して続きから再開できる。
 */
export interface BackfillOptions {
  readonly apiKey: string;
  readonly baseUrl: string;
  readonly from: string;
  readonly to: string;
  readonly out: string;
  /** リクエスト間隔（ミリ秒）。レート制限に当てないための間引き。 */
  readonly delayMs: number;
}

export async function runBackfill(options: BackfillOptions): Promise<number> {
  const client = new Jquants(options.apiKey, options.baseUrl);

  // 営業日だけを取りに行く。休日に投げても空が返るだけで時間の無駄になる。
  console.error(`営業日カレンダーを取得: ${options.from} 〜 ${options.to}`);
  const calendar = await client.getAll(
    '/markets/trading_calendar',
    { from: options.from, to: options.to },
    'trading_calendar',
  );
  const tradingDays = calendar
    .filter((r) => client.stringOf(r, 'holidayDivision') !== '0')
    .map((r) => client.stringOf(r, 'date'))
    .filter((d): d is string => d !== null)
    .sort();

  console.error(`対象営業日: ${tradingDays.length} 日`);
  if (tradingDays.length === 0) {
    console.error('営業日が 0 件。日付の範囲と契約プランを確認すること。');
    return 1;
  }

  const statements: string[] = [
    '-- 自動生成（npm run backfill）。D1 へ流し込む用。手で編集しないこと。',
    `-- 期間: ${options.from} 〜 ${options.to} / 営業日 ${tradingDays.length} 日`,
    '',
  ];

  statements.push(
    ...insertStatements(
      'market_calendar',
      ['market', 'date', 'is_open'],
      tradingDays.map((d) => ['JP', d, 1]),
      { conflictTarget: 'market, date' },
    ),
  );

  let totalRows = 0;
  for (const [i, date] of tradingDays.entries()) {
    const rows = await client.getAll('/prices/daily_quotes', { date }, 'daily_quotes');
    const priceRows: (readonly unknown[])[] = [];
    for (const row of rows) {
      const code = client.stringOf(row, 'code');
      const close = client.numberOf(row, 'close');
      // 売買が成立しなかった銘柄は行を作らない（0 で埋めると指標が壊れる）。
      if (code === null || close === null) continue;
      priceRows.push([
        toSymbolId('JP', code),
        client.stringOf(row, 'date') ?? date,
        client.numberOf(row, 'open') ?? close,
        client.numberOf(row, 'high') ?? close,
        client.numberOf(row, 'low') ?? close,
        close,
        client.numberOf(row, 'volume') ?? 0,
        client.numberOf(row, 'turnover'),
        client.numberOf(row, 'adjustmentFactor') ?? 1,
      ]);
    }
    statements.push(
      ...insertStatements(
        'prices_daily',
        ['symbol_id', 'date', 'open', 'high', 'low', 'close', 'volume', 'turnover', 'adjustment_factor'],
        priceRows,
        { conflictTarget: 'symbol_id, date' },
      ),
    );
    totalRows += priceRows.length;

    if ((i + 1) % 20 === 0 || i === tradingDays.length - 1) {
      console.error(`  ${i + 1}/${tradingDays.length} 日  累計 ${totalRows} 行`);
    }
    if (options.delayMs > 0) await sleep(options.delayMs);
  }

  await mkdir(dirname(options.out), { recursive: true });
  await writeFile(options.out, statements.join('\n') + '\n', 'utf8');
  console.error(`\n${options.out} に ${totalRows} 行を書き出した。`);
  console.error('D1 へ流し込む:');
  console.error(`  npx wrangler d1 execute invest-db --remote --file=${options.out}`);
  return 0;
}
