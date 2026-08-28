/** SQL リテラルの組み立て。D1 へ流し込む .sql を作るために使う。 */

export function q(value: unknown): string {
  if (value === null || value === undefined) return 'NULL';
  if (typeof value === 'number') return Number.isFinite(value) ? String(value) : 'NULL';
  if (typeof value === 'boolean') return value ? '1' : '0';
  return `'${String(value).replace(/'/g, "''")}'`;
}

/**
 * 複数行の INSERT を、1 文が長くなりすぎない大きさに割って返す。
 * D1 は 1 文あたりのサイズに上限があるので、まとめすぎると失敗する。
 */
export function insertStatements(
  table: string,
  columns: readonly string[],
  rows: readonly (readonly unknown[])[],
  options: { conflictTarget?: string; rowsPerStatement?: number } = {},
): string[] {
  if (rows.length === 0) return [];
  const size = options.rowsPerStatement ?? 200;
  const suffix =
    options.conflictTarget === undefined
      ? ''
      : ` ON CONFLICT (${options.conflictTarget}) DO NOTHING`;

  const out: string[] = [];
  for (let i = 0; i < rows.length; i += size) {
    const values = rows
      .slice(i, i + size)
      .map((r) => `(${r.map(q).join(',')})`)
      .join(',\n  ');
    out.push(`INSERT INTO ${table} (${columns.join(', ')}) VALUES\n  ${values}${suffix};`);
  }
  return out;
}
