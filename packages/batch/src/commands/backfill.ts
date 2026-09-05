import { writeFile, mkdir } from 'node:fs/promises';
import { dirname } from 'node:path';
import { toSymbolId } from '@invest/core';
import { Jquants, JP_PATHS, sleep } from '../jquants.js';
import { insertStatements } from '../sql.js';

/**
 * 過去の日足をまとめて取得し、D1 へ流し込む .sql を書き出す。
 *
 * **これを Worker でやらない理由**は 2 つ。
 *   1. 行数が多い。日足は 1 日あたり約 4,000 行（全銘柄）返るので、
 *      2 年で約 200 万行になる。Worker の D1 書き込みでは捌けない
 *   2. 取得だけで営業日の数だけリクエストが要る（2 年で約 490 回）
 * GitHub Actions で回して結果だけ流し込むほうが速く、途中で失敗しても
 * 続きから再開できる。
 *
 * **出力は容量で分割する。** 2 年ぶんを 1 ファイルにすると約 180 MB になり、
 * `wrangler d1 execute --file` に渡せない。`--out` は接頭辞として扱い、
 * `backfill-001.sql`, `backfill-002.sql`, … と連番で書き出す。
 *
 * **適用は必ず連番の順。** `market_calendar` と `symbols` の INSERT が
 * `prices_daily` より先に来る必要がある（外部キー）。番号はゼロ埋めして
 * あるので、`ls | sort` の順で正しい。
 *
 * **銘柄は絞らない。** 「今日の出来高上位 N 本」に絞ると、過去に上位だった
 * 銘柄が落ちて選択バイアスが入る（CLAUDE.md の Point-in-Time）。
 * D1 の容量に対して 200 万行は問題にならない。困るのは 1 ファイルの
 * 大きさだけなので、そこだけ直してある。
 */

/** 1 ファイルの上限。D1 の取り込みに余裕を持たせた値。 */
export const DEFAULT_MAX_BYTES = 5 * 1024 * 1024;

/**
 * 連番のファイル名を作る。**ゼロ埋めする。**
 * `backfill-10.sql` が `backfill-2.sql` より前に並ぶと、
 * prices_daily が market_calendar より先に流れて外部キーで落ちる。
 */
export function chunkPath(prefix: string, index: number): string {
  const base = prefix.replace(/\.sql$/, '');
  return `${base}-${String(index).padStart(3, '0')}.sql`;
}

/**
 * 文の並びを、容量の上限で切り分ける。**順序は保つ。**
 *
 * 1 つの文が上限を超えていても分割しない（SQL として壊れる）。
 * その場合はその文だけで 1 ファイルになる。
 */
export function splitByBytes(statements: readonly string[], maxBytes: number): string[][] {
  const chunks: string[][] = [];
  let current: string[] = [];
  let size = 0;
  for (const stmt of statements) {
    const bytes = Buffer.byteLength(stmt, 'utf8') + 1; // 改行ぶん
    if (current.length > 0 && size + bytes > maxBytes) {
      chunks.push(current);
      current = [];
      size = 0;
    }
    current.push(stmt);
    size += bytes;
  }
  if (current.length > 0) chunks.push(current);
  return chunks;
}
export interface BackfillOptions {
  readonly apiKey: string;
  readonly baseUrl: string;
  readonly from: string;
  readonly to: string;
  readonly out: string;
  /** リクエスト間隔（ミリ秒）。レート制限に当てないための間引き。 */
  readonly delayMs: number;
  /** 1 ファイルの上限（バイト）。既定は `DEFAULT_MAX_BYTES`。 */
  readonly maxBytes?: number;
}

export async function runBackfill(options: BackfillOptions): Promise<number> {
  const client = new Jquants(options.apiKey, options.baseUrl);

  // 営業日だけを取りに行く。休日に投げても空が返るだけで時間の無駄になる。
  console.error(`営業日カレンダーを取得: ${options.from} 〜 ${options.to}`);
  const calendar = await client.getAll(JP_PATHS.calendar, {
    from: options.from,
    to: options.to,
  });
  // **推測で埋めない。取れなければ止める。**
  // `stringOf(...) !== '0'` は、別名が当たらないと null !== '0' で true になり、
  // **祝日がすべて営業日として数えられる**。例外も出ないので気付けない。
  // 実際そうなっていた（実物の項目名は HolDiv で、別名表に無かった）。
  const tradingDays = calendar
    .filter((r) => {
      const division = client.stringOf(r, 'holidayDivision');
      if (division === null) {
        throw new Error(
          `営業日区分が読めない（${JP_PATHS.calendar}）。実際のキー: ${Object.keys(r).join(', ')}。` +
            'JQUANTS_FIELD_ALIASES に別名を足すこと。',
        );
      }
      return division !== '0';
    })
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
    const rows = await client.getAll(JP_PATHS.dailyBars, { date });
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
  const chunks = splitByBytes(statements, options.maxBytes ?? DEFAULT_MAX_BYTES);
  const written: string[] = [];
  for (const [i, chunk] of chunks.entries()) {
    const path = chunkPath(options.out, i + 1);
    await writeFile(path, chunk.join('\n') + '\n', 'utf8');
    written.push(path);
  }

  console.error(`\n${totalRows} 行を ${written.length} ファイルに書き出した:`);
  for (const path of written) console.error(`  ${path}`);
  console.error('\nD1 へ流し込む（**必ずこの順に**。外部キーがあるので順序が要る）:');
  console.error(`  for f in $(ls ${chunkPath(options.out, 1).replace(/-001\.sql$/, '')}-*.sql | sort); do`);
  console.error('    npx wrangler d1 execute invest-db --remote --env production --file="$f"');
  console.error('  done');
  console.error('\n途中で失敗したら、失敗したファイルから再開してよい');
  console.error('（ON CONFLICT DO NOTHING なので、重ねて流しても壊れない）。');
  return 0;
}
