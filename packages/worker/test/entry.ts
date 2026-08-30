/**
 * テスト用のバンドル入口。
 *
 * 本番の入口（`src/index.ts`）は既定エクスポートしか持たないので、
 * 内部関数を確かめるための口をここに置く。**`src/` にテスト専用の
 * エクスポートを混ぜないため**に、この 1 枚をテスト側に置いている。
 */
export { default as handler } from '../src/index.js';
export * from '../src/db/queries.js';
export * from '../src/jobs/date.js';
export { runDailyPipeline, JOB_NAME } from '../src/jobs/dailyPipeline.js';
export {
  JquantsClient,
  JquantsJpSource,
  JquantsError,
  FIELD_ALIASES,
  parseAliases,
} from '../src/connectors/jquants.js';
export { sparkline } from '../src/ui/sparkline.js';
export { escapeHtml, num, price, pct, verdictLabel } from '../src/ui/format.js';
export { layout } from '../src/ui/layout.js';
export { dashboardPage, rankingTable, symbolPage } from '../src/ui/pages.js';
export { isAccessConfigured, isMemberSignupEnabled } from '../src/auth.js';
export { resolveSite, normalisePath, lpBasePath, appUrl } from '../src/site.js';
export { normaliseEmail } from '../src/routes/waitlist.js';
export { lpPage } from '../src/ui/lp.js';
