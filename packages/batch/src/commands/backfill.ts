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

/** `/equities/master` から拾う、銘柄の付随情報。 */
export interface MasterRow {
  readonly code: string;
  readonly name: string;
  readonly sector33: string | null;
  readonly sector17: string | null;
}

/** `prices_daily` の列順。**production とテストで同じものを使う。** */
const PRICE_COLUMNS = [
  'symbol_id', 'date', 'open', 'high', 'low', 'close', 'volume', 'turnover', 'adjustment_factor',
] as const;

/** 日足の INSERT 文。1 日ぶんずつ呼ぶ。 */
export function priceInsertStatements(rows: readonly (readonly unknown[])[]): string[] {
  return insertStatements('prices_daily', [...PRICE_COLUMNS], rows, {
    conflictTarget: 'symbol_id, date',
  });
}

/**
 * `symbols` の INSERT 文。
 *
 * **日足に出てきた銘柄は、必ず行を作る。** master に載っている銘柄だけに
 * すると、期間の途中で上場廃止になった銘柄の価格が外部キーで弾かれる
 * （prices_daily → symbols の FK。migrations/0001_init.sql:63）。
 * CLAUDE.md の「上場廃止銘柄を symbols から消さない」の裏返し。
 *
 * master に無ければ `name = code` の最小行にする。
 * **`delisted_at` は入れない。** master に無い＝廃止とは限らない
 * （`from` の時点でまだ上場していなかっただけかもしれない）。
 * 廃止の判定は日次パイプラインの仕事で、あちらは ON CONFLICT DO UPDATE
 * なので、名前も業種もあとから整う。
 */
export function symbolInsertStatements(
  seen: ReadonlyMap<string, string>,
  master: ReadonlyMap<string, MasterRow>,
  now: string,
): string[] {
  const rows = [...seen.entries()]
    .sort(([a], [b]) => (a < b ? -1 : a > b ? 1 : 0))
    .map(([symbolId, code]) => {
      const info = master.get(symbolId);
      return [
        symbolId,
        'JP',
        code,
        info?.name ?? code,
        info?.sector33 ?? null,
        info?.sector17 ?? null,
        'JPY',
        now,
      ] as const;
    });
  return insertStatements(
    'symbols',
    ['symbol_id', 'market', 'code', 'name', 'sector33', 'sector17', 'currency', 'updated_at'],
    rows,
    { conflictTarget: 'symbol_id' },
  );
}

/**
 * 文を並べる。**順序がすべて。**
 *
 *   market_calendar → symbols → prices_daily
 *
 * `prices_daily` は `symbols` を参照しているので、逆にすると
 * `FOREIGN KEY constraint failed` で落ちる。連番ファイルに切るのは
 * このあとなので、ここでの並びがそのまま適用順になる。
 */
export function assembleBackfill(input: {
  readonly from: string;
  readonly to: string;
  readonly tradingDays: readonly string[];
  readonly seen: ReadonlyMap<string, string>;
  readonly master: ReadonlyMap<string, MasterRow>;
  readonly priceStatements: readonly string[];
  readonly now: string;
}): string[] {
  return [
    '-- 自動生成（npm run backfill）。D1 へ流し込む用。手で編集しないこと。',
    `-- 期間: ${input.from} 〜 ${input.to} / 営業日 ${input.tradingDays.length} 日`,
    `-- 銘柄: ${input.seen.size}`,
    '',
    ...insertStatements(
      'market_calendar',
      ['market', 'date', 'is_open'],
      input.tradingDays.map((d) => ['JP', d, 1]),
      { conflictTarget: 'market, date' },
    ),
    ...symbolInsertStatements(input.seen, input.master, input.now),
    ...input.priceStatements,
  ];
}

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

  // **銘柄の名前と業種を先に引く。** 期間の両端で引くのは、途中で
  // 上場廃止になった銘柄の名前が `to` 時点では取れないため。2 回で済む。
  const master = new Map<string, MasterRow>();
  for (const asOf of new Set([options.from, options.to])) {
    console.error(`銘柄一覧を取得: ${asOf}`);
    for (const row of await client.getAll(JP_PATHS.master, { date: asOf })) {
      const code = client.stringOf(row, 'code');
      if (code === null) continue;
      const symbolId = toSymbolId('JP', code);
      // `to` を後に見るので、あとから来たほうが勝つ（新しい名前を優先）。
      master.set(symbolId, {
        code,
        name: client.stringOf(row, 'companyName') ?? code,
        sector33: client.stringOf(row, 'sector33'),
        sector17: client.stringOf(row, 'sector17'),
      });
    }
    if (options.delayMs > 0) await sleep(options.delayMs);
  }
  console.error(`銘柄一覧: ${master.size} 件`);

  // 日足に出てきた銘柄。**master に無いものもここに入る**（期間中に廃止）。
  const seen = new Map<string, string>();
  const priceStatements: string[] = [];

  let totalRows = 0;
  for (const [i, date] of tradingDays.entries()) {
    const rows = await client.getAll(JP_PATHS.dailyBars, { date });
    const priceRows: (readonly unknown[])[] = [];
    for (const row of rows) {
      const code = client.stringOf(row, 'code');
      const close = client.numberOf(row, 'close');
      // 売買が成立しなかった銘柄は行を作らない（0 で埋めると指標が壊れる）。
      if (code === null || close === null) continue;
      const symbolId = toSymbolId('JP', code);
      seen.set(symbolId, code);
      priceRows.push([
        symbolId,
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
    priceStatements.push(...priceInsertStatements(priceRows));
    totalRows += priceRows.length;

    if ((i + 1) % 20 === 0 || i === tradingDays.length - 1) {
      console.error(`  ${i + 1}/${tradingDays.length} 日  累計 ${totalRows} 行`);
    }
    if (options.delayMs > 0) await sleep(options.delayMs);
  }

  // **組み立ては最後。** symbols の中身は全日を見終わるまで確定しない。
  const statements = assembleBackfill({
    from: options.from,
    to: options.to,
    tradingDays,
    seen,
    master,
    priceStatements,
    now: new Date().toISOString(),
  });

  await mkdir(dirname(options.out), { recursive: true });
  const chunks = splitByBytes(statements, options.maxBytes ?? DEFAULT_MAX_BYTES);
  const written: string[] = [];
  for (const [i, chunk] of chunks.entries()) {
    const path = chunkPath(options.out, i + 1);
    await writeFile(path, chunk.join('\n') + '\n', 'utf8');
    written.push(path);
  }

  console.error(`\n日足 ${totalRows} 行 / 銘柄 ${seen.size} 件を ${written.length} ファイルに書き出した:`);
  for (const path of written) console.error(`  ${path}`);
  console.error('\nD1 へ流し込む（**必ずこの順に**。外部キーがあるので順序が要る）:');
  console.error(`  for f in $(ls ${chunkPath(options.out, 1).replace(/-001\.sql$/, '')}-*.sql | sort); do`);
  console.error('    npx wrangler d1 execute invest-db --remote --env production --file="$f"');
  console.error('  done');
  console.error('\n途中で失敗したら、失敗したファイルから再開してよい');
  console.error('（ON CONFLICT DO NOTHING なので、重ねて流しても壊れない）。');
  return 0;
}
