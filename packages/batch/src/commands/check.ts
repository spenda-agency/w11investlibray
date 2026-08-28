import { Jquants } from '../jquants.js';

/**
 * 疎通確認。
 *
 * **API が実際に返してきた項目名をそのまま表示する。**
 * V2 で項目名が短縮されたうえ、プランによって返る項目も違うので、
 * 「動くはず」ではなく実際の姿を見てから設計を確定させる。
 * ここの出力を docs/DATA-SOURCES.md に貼ること。
 */
export async function runCheck(apiKey: string, baseUrl: string, date: string): Promise<number> {
  const client = new Jquants(apiKey, baseUrl);
  console.log(`J-Quants 疎通確認  base=${baseUrl}  date=${date}\n`);

  const endpoints: [string, string, Record<string, string>, string][] = [
    ['銘柄一覧', '/listed/info', { date }, 'info'],
    ['日足', '/prices/daily_quotes', { date }, 'daily_quotes'],
    ['営業日', '/markets/trading_calendar', { from: date, to: date }, 'trading_calendar'],
    ['財務', '/fins/statements', { date }, 'statements'],
    ['決算発表予定', '/fins/announcement', {}, 'announcement'],
  ];

  let failures = 0;
  for (const [label, path, params, key] of endpoints) {
    const { status, body } = await client.probe(path, params);
    if (status !== 200) {
      // 403 は多くの場合「契約プランに含まれていない」。異常ではないので区別する。
      const hint = status === 403 ? '（契約プランの範囲外の可能性）' : '';
      console.log(`✗ ${label.padEnd(14)} ${path}  HTTP ${status} ${hint}`);
      if (status !== 403) failures += 1;
      continue;
    }
    const rows = (body as Record<string, unknown>)[key];
    const list = Array.isArray(rows) ? (rows as Record<string, unknown>[]) : [];
    console.log(`✓ ${label.padEnd(14)} ${path}  ${list.length} 件`);
    const first = list[0];
    if (first !== undefined) {
      console.log(`    実際の項目名: ${Object.keys(first).join(', ')}`);
    }
  }

  console.log(`
出力の読み方
  - 「実際の項目名」が既定の別名表に無いときは、
    packages/worker/src/connectors/jquants.ts と packages/batch/src/jquants.ts の
    FIELD_ALIASES に足すか、環境変数 JQUANTS_FIELD_ALIASES で上書きする。
  - 403 は契約プランの範囲外。Phase 1 に必要なのは
    /listed/info と /prices/daily_quotes と /markets/trading_calendar の 3 本。
  - 確認できた内容を docs/DATA-SOURCES.md に日付付きで記録すること。`);

  return failures === 0 ? 0 : 1;
}
