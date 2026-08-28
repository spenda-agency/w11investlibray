import { pathToFileURL } from 'node:url';
import { runCheck } from './commands/check.js';
import { runBackfill } from './commands/backfill.js';
import { runBacktestCommand } from './commands/backtest.js';
import { DEFAULT_BASE_URL } from './jquants.js';

// テストから使う口。CLI 本体の引数解析やルール解決を、実行せずに確かめられるようにする。
export { resolveRule, runBacktestCommand } from './commands/backtest.js';
export { insertStatements, q } from './sql.js';

/**
 * 重い処理の入口。GitHub Actions から叩く。
 *
 *   npm run check:datasource
 *   npm run backfill -- --from 2016-01-01 --to 2026-08-27
 *   npm run backtest -- --input out/prices.json --rule golden-cross
 */
const USAGE = `使い方

  check                              疎通・契約プラン・実際の項目名を確認する
    --date YYYY-MM-DD                既定は 3 営業日前

  backfill                           過去の日足を取得して D1 用の .sql を書き出す
    --from YYYY-MM-DD  (必須)
    --to   YYYY-MM-DD  (必須)
    --out  path                      既定 out/backfill.sql
    --delay ms                       リクエスト間隔。既定 200

  backtest                           ルールを過去データで検証する
    --input path   (必須)            {"JP.72030":[{date,open,high,low,close,volume,adjustmentFactor}]}
    --rule  name                     golden-cross | score-NN。既定 golden-cross
    --universe name                  既定 JP500
    --cost  0.001                    片道の手数料・スリッページ
    --hold  60                       最長保有営業日数
    --out   path                     既定 out/backtest.sql

環境変数
  JQUANTS_API_KEY    J-Quants の API キー（check / backfill で必須）
  JQUANTS_BASE_URL   既定 ${DEFAULT_BASE_URL}
`;

export function parseArgs(argv: readonly string[]): { command: string; flags: Record<string, string> } {
  const [command = '', ...rest] = argv;
  const flags: Record<string, string> = {};
  for (let i = 0; i < rest.length; i += 1) {
    const token = rest[i];
    if (token === undefined || !token.startsWith('--')) continue;
    const key = token.slice(2);
    const next = rest[i + 1];
    if (next === undefined || next.startsWith('--')) {
      flags[key] = 'true';
    } else {
      flags[key] = next;
      i += 1;
    }
  }
  return { command, flags };
}

/** n 営業日前のおおよその日付（土日だけ避ける簡易版。check の既定値用）。 */
export function recentWeekday(from: Date, back: number): string {
  const d = new Date(from);
  let moved = 0;
  while (moved < back) {
    d.setUTCDate(d.getUTCDate() - 1);
    const day = d.getUTCDay();
    if (day !== 0 && day !== 6) moved += 1;
  }
  return d.toISOString().slice(0, 10);
}

async function main(): Promise<number> {
  const { command, flags } = parseArgs(process.argv.slice(2));
  const apiKey = process.env['JQUANTS_API_KEY'] ?? '';
  const baseUrl = process.env['JQUANTS_BASE_URL'] ?? DEFAULT_BASE_URL;

  switch (command) {
    case 'check': {
      if (!apiKey) {
        console.error('JQUANTS_API_KEY が未設定。');
        return 1;
      }
      return runCheck(apiKey, baseUrl, flags['date'] ?? recentWeekday(new Date(), 3));
    }
    case 'backfill': {
      if (!apiKey) {
        console.error('JQUANTS_API_KEY が未設定。');
        return 1;
      }
      const from = flags['from'];
      const to = flags['to'];
      if (from === undefined || to === undefined) {
        console.error('--from と --to は必須。');
        return 1;
      }
      return runBackfill({
        apiKey,
        baseUrl,
        from,
        to,
        out: flags['out'] ?? 'out/backfill.sql',
        delayMs: Number(flags['delay'] ?? '200'),
      });
    }
    case 'backtest': {
      const input = flags['input'];
      if (input === undefined) {
        console.error('--input は必須。');
        return 1;
      }
      return runBacktestCommand({
        input,
        out: flags['out'] ?? 'out/backtest.sql',
        ruleName: flags['rule'] ?? 'golden-cross',
        universe: flags['universe'] ?? 'JP500',
        costPerSide: Number(flags['cost'] ?? '0.001'),
        maxHoldBars: Number(flags['hold'] ?? '60'),
      });
    }
    default:
      console.log(USAGE);
      return command === '' || command === 'help' ? 0 : 1;
  }
}

// **直接実行されたときだけ動かす。**
// `argv[1] に 'cli' を含むか` のような緩い判定にすると、
// テストファイル名に cli が入っているだけで main() が走り、
// process.exit でテスト実行そのものが途中終了する（実際にやらかした）。
const isEntryPoint = (() => {
  const entry = process.argv[1];
  if (entry === undefined) return false;
  try {
    return import.meta.url === pathToFileURL(entry).href;
  } catch {
    return false;
  }
})();

if (isEntryPoint) {
  main().then(
    (code) => process.exit(code),
    (err: unknown) => {
      console.error(err instanceof Error ? `${err.name}: ${err.message}` : String(err));
      process.exit(1);
    },
  );
}
