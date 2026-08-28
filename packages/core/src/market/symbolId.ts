import type { MarketCode } from '../types.js';

/**
 * `symbol_id` は名前空間付きの文字列にする（`JP.7203` / `US.NVDA` / `FX.USDJPY`）。
 *
 * Phase 3 で米国株、Phase 4 で FX を足すときにスキーマを変えずに済ませるため。
 * 数値コードのままにすると、日本の 7203 と将来のどこかの 7203 が衝突する。
 */

export const MARKET_CODES: readonly MarketCode[] = ['JP', 'US', 'FX'];

const SEPARATOR = '.';

export function toSymbolId(market: MarketCode, code: string): string {
  const trimmed = code.trim().toUpperCase();
  if (trimmed === '') throw new RangeError('code が空');
  if (trimmed.includes(SEPARATOR)) {
    throw new RangeError(`code に "${SEPARATOR}" を含められない: ${code}`);
  }
  return `${market}${SEPARATOR}${trimmed}`;
}

export interface ParsedSymbolId {
  readonly market: MarketCode;
  readonly code: string;
}

export function parseSymbolId(symbolId: string): ParsedSymbolId {
  const at = symbolId.indexOf(SEPARATOR);
  if (at < 0) throw new RangeError(`symbol_id の形式が不正: ${symbolId}`);
  const market = symbolId.slice(0, at) as MarketCode;
  const code = symbolId.slice(at + 1);
  if (!MARKET_CODES.includes(market) || code === '') {
    throw new RangeError(`symbol_id の形式が不正: ${symbolId}`);
  }
  return { market, code };
}

/**
 * 日本株の 4 桁コードを J-Quants の 5 桁形式（末尾 0）へ。
 * 既に 5 桁なら何もしない。
 *
 * **英数字コードに対応していること。** 東証は 2024 年から `130A` のような
 * 英字を含む 4 桁コードを採番しており、数字だけを想定すると新規上場が
 * 丸ごと欠落する。
 */
export function toJquantsCode(code: string): string {
  const t = code.trim().toUpperCase();
  if (/^[0-9A-Z]{4}$/.test(t)) return `${t}0`;
  return t;
}

/** J-Quants の 5 桁コードを表示用の 4 桁へ戻す（末尾が 0 のときだけ）。 */
export function toDisplayCode(code: string): string {
  const t = code.trim().toUpperCase();
  if (/^[0-9A-Z]{5}$/.test(t) && t.endsWith('0')) return t.slice(0, 4);
  return t;
}
