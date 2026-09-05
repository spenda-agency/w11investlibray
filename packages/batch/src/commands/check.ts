import { Jquants } from '../jquants.js';

/**
 * 疎通確認。
 *
 * **API が実際に返してきた項目名をそのまま表示する。**
 * V2 で項目名が短縮されたうえ、プランによって返る項目も違うので、
 * 「動くはず」ではなく実際の姿を見てから設計を確定させる。
 * ここの出力を docs/DATA-SOURCES.md に貼ること。
 *
 * **失敗したときに何が悪いのかを言うのが、このコマンドの半分の仕事。**
 * 状態コードだけ出して本文を捨てていた時期があり、Light プランに
 * 上げた直後の全 403 を「契約プランの範囲外」と誤診した。
 * API は 403 の本文に理由を書いてくるので、それを必ず出す。
 */

/** Phase 1 の日次パイプラインが実際に叩くもの。ここが通らなければ先へ進めない。 */
const REQUIRED = new Set(['/listed/info', '/prices/daily_quotes', '/markets/trading_calendar']);

interface Probe {
  (path: string, params: Record<string, string>): Promise<{ status: number; body: unknown }>;
}

/**
 * 応答本文から、人が読める理由を 1 行取り出す。
 *
 * J-Quants は `{"message": "..."}` を返す。形が変わっても何か出せるように、
 * よくあるキーを順に見て、無ければ本文そのものを短く切る。
 */
export function reasonFrom(body: unknown): string {
  if (typeof body === 'string') return body.slice(0, 200);
  if (body === null || typeof body !== 'object') return '';
  const obj = body as Record<string, unknown>;
  for (const key of ['message', 'Message', 'error', 'detail']) {
    const v = obj[key];
    if (typeof v === 'string' && v.trim() !== '') return v.slice(0, 200);
  }
  return JSON.stringify(obj).slice(0, 200);
}

export async function runCheck(
  apiKey: string,
  baseUrl: string,
  date: string,
  probe?: Probe,
): Promise<number> {
  // テストから差し込めるようにしてある。既定は本物のクライアント。
  const call: Probe = probe ?? ((path, params) => new Jquants(apiKey, baseUrl).probe(path, params));
  console.log(`J-Quants 疎通確認  base=${baseUrl}  date=${date}\n`);

  const endpoints: [string, string, Record<string, string>, string][] = [
    ['銘柄一覧', '/listed/info', { date }, 'info'],
    ['日足', '/prices/daily_quotes', { date }, 'daily_quotes'],
    ['営業日', '/markets/trading_calendar', { from: date, to: date }, 'trading_calendar'],
    ['財務', '/fins/statements', { date }, 'statements'],
    ['決算発表予定', '/fins/announcement', {}, 'announcement'],
  ];

  let ok = 0;
  let forbidden = 0;
  const missingRequired: string[] = [];

  for (const [label, path, params, key] of endpoints) {
    const { status, body } = await call(path, params);
    if (status !== 200) {
      console.log(`✗ ${label.padEnd(14)} ${path}  HTTP ${status}`);
      // **理由を必ず出す。** ここを捨てると、次に何をすればいいか分からない。
      const reason = reasonFrom(body);
      if (reason !== '') console.log(`    → ${reason}`);
      if (status === 403) forbidden += 1;
      if (REQUIRED.has(path)) missingRequired.push(path);
      continue;
    }
    ok += 1;
    const rows = (body as Record<string, unknown>)[key];
    const list = Array.isArray(rows) ? (rows as Record<string, unknown>[]) : [];
    console.log(`✓ ${label.padEnd(14)} ${path}  ${list.length} 件`);
    const first = list[0];
    if (first !== undefined) {
      console.log(`    実際の項目名: ${Object.keys(first).join(', ')}`);
    }
  }

  console.log('');

  // **403 の意味は、1 本ずつでは決まらない。全体を見てから言う。**
  // /listed/info は最下位のプランでも通るので、全部 403 なら
  // 「プランの範囲外」ではありえない。キーのほうを疑う。
  if (ok === 0 && forbidden === endpoints.length) {
    console.log(`すべて 403。契約プランの範囲外ではなく、キーが効いていない可能性が高い。
  /listed/info は最下位のプランでも通るので、全部が 403 になる説明にならない。
  疑う順に:
    1. プランを上げる前に発行したキーを使っている → 発行し直す
    2. プラン変更がまだ反映されていない → 少し待ってもう一度
    3. 別のプロジェクトのキーを渡している → ダッシュボードで確認する
  上に出ている「→」の行が、API 自身の言い分。まずそれを読むこと。`);
  } else if (missingRequired.length > 0) {
    console.log(`日次パイプラインに必要な ${missingRequired.join(' / ')} が取れない。
  ここが通らないとトラック B は進められない。プランの内容を確認すること。`);
  } else if (forbidden > 0) {
    console.log(`403 が出ているのは Phase 1b で使うもの（/fins/*）だけ。先へ進んでよい。
  財務データを使う段階になったらプランを見直す。`);
  }

  console.log(`
出力の読み方
  - 「実際の項目名」が既定の別名表に無いときは、
    packages/worker/src/connectors/jquants.ts と packages/batch/src/jquants.ts の
    FIELD_ALIASES に足すか、環境変数 JQUANTS_FIELD_ALIASES で上書きする。
  - 日次パイプラインに要るのは
    /listed/info と /prices/daily_quotes と /markets/trading_calendar の 3 本。
  - 確認できた内容を docs/DATA-SOURCES.md に日付付きで記録すること。`);

  // /fins/* だけの 403 は成功扱い（Phase 1b の話なので、いま止める理由がない）。
  return missingRequired.length === 0 ? 0 : 1;
}
