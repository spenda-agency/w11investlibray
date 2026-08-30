import type { Env } from '../types.js';
import { json } from './api.js';

/**
 * 先行登録の受け口。**LP 側（認証なし）で公開される唯一の書き込み口。**
 *
 * 公開の書き込み口なので、守りをコードの側に寄せてある。
 *   - POST のみ。フォームと JSON の両方を受ける
 *   - ハニーポット項目が埋まっていたら、成功したふりをして捨てる
 *   - 同意チェックが無ければ受け付けない（同意した時刻を保存する）
 *   - 既に登録済みでも同じ応答を返す（登録の有無を外から探れないようにする）
 *   - 1 日あたりの登録数に上限を置く
 *
 * **生の IP アドレスは保存しない。** 濫用対策は上限で足りるし、
 * 持たなければ漏れない。本気の対策は Cloudflare 側の Rate Limiting で行う
 * （docs/DEPLOY.md）。
 */

/** 1 日に受け付ける登録数の上限。超えたら 503 を返す。 */
const DAILY_CAP = 500;

/** メールアドレスの最大長。RFC 上の上限に合わせる。 */
const MAX_EMAIL_LENGTH = 254;

/**
 * 実務的なメール判定。RFC を完全に満たす正規表現は書かない
 * （長くて読めず、それでも誤判定する）。明らかな不正だけ弾く。
 */
const EMAIL_RE = /^[^\s@,;:<>()[\]\\"]+@[^\s@.]+(\.[^\s@.]+)+$/;

export interface WaitlistInput {
  readonly email: string;
  readonly consent: boolean;
  readonly honeypot: string;
  readonly source: string;
}

export async function handleWaitlist(request: Request, env: Env): Promise<Response> {
  if (request.method !== 'POST') return json({ error: 'POST で送信すること' }, 405);

  let input: WaitlistInput;
  try {
    input = await readInput(request);
  } catch {
    return json({ error: '入力を読み取れなかった' }, 400);
  }

  // ハニーポット。人には見えない項目が埋まっていれば自動投稿とみなす。
  // 弾いたことを教えない（教えると避け方が分かる）。
  if (input.honeypot.trim() !== '') return json({ ok: true });

  const email = normaliseEmail(input.email);
  if (email === null) return json({ error: 'メールアドレスの形式が正しくない' }, 422);
  if (!input.consent) return json({ error: '同意のチェックが必要' }, 422);

  const now = new Date().toISOString();
  const today = now.slice(0, 10);

  const count = await env.INVEST_DB.prepare(
    `SELECT COUNT(*) AS n FROM waitlist WHERE created_at >= ?1`,
  )
    .bind(`${today}T00:00:00.000Z`)
    .first<{ n: number }>();
  if ((count?.n ?? 0) >= DAILY_CAP) {
    return json({ error: '本日の受付上限に達した。時間をおいて試すこと' }, 503);
  }

  await env.INVEST_DB.prepare(
    `INSERT INTO waitlist (email, created_at, consented_at, source, locale, status)
     VALUES (?1, ?2, ?2, ?3, ?4, 'pending')
     ON CONFLICT (email) DO NOTHING`,
  )
    .bind(email, now, input.source.slice(0, 40) || 'lp', 'ja')
    .run();

  // 既に登録済みでも同じ応答。登録の有無を外から確かめられないようにする。
  return json({ ok: true });
}

async function readInput(request: Request): Promise<WaitlistInput> {
  const type = request.headers.get('content-type') ?? '';
  if (type.includes('application/json')) {
    const body = (await request.json()) as Record<string, unknown>;
    return {
      email: str(body['email']),
      consent: body['consent'] === true || str(body['consent']) === 'on',
      honeypot: str(body['company']),
      source: str(body['source']),
    };
  }
  const form = await request.formData();
  return {
    email: str(form.get('email')),
    consent: form.get('consent') !== null,
    honeypot: str(form.get('company')),
    source: str(form.get('source')),
  };
}

function str(v: unknown): string {
  return typeof v === 'string' ? v : '';
}

/** 小文字化して前後の空白を落とす。判定に通らなければ `null`。 */
export function normaliseEmail(raw: string): string | null {
  const email = raw.trim().toLowerCase();
  if (email.length === 0 || email.length > MAX_EMAIL_LENGTH) return null;
  if (!EMAIL_RE.test(email)) return null;
  return email;
}
