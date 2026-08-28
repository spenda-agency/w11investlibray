# ロードマップ — Phase とブランチの対応

サブブランチで機能を足していく前提で、**変わらない継ぎ目**を Phase 1 で先に作ってある。

| Phase | ブランチ | 内容 | 状態 |
|---|---|---|---|
| **1** | `claude/stock-screening-ai-library-35qwmk` | 日本株 500 銘柄・日足・指標・シグナル・スコア・画面 | 実装中 |
| 1b | `feat/news-ai` | ニュース取得と AI 分析、`c_news` / `c_fundamental` | 未着手 |
| 2 | `feat/universe-jp-all` | 日本株全銘柄（約 4,000）。Queues を導入 | 未着手 |
| 3 | `feat/market-us` | 米国株 | 未着手 |
| 4 | `feat/market-fx` | FX | 未着手 |
| 5 | `feat/backtest` | バックテストの本実装と結果画面 | 未着手 |
| 6 | `feat/ai-assistant` | 自然言語での銘柄照会（Vectorize / RAG） | 未着手 |
| 7 | `feat/user-strategy` | ユーザーごとの投資条件とランキング | 未着手 |

---

## Phase 1 で用意済みの継ぎ目

各 Phase が「新しく作る」のではなく「空いている穴を埋める」形になるようにしてある。

| Phase | 埋める穴 |
|---|---|
| 1b | `news` / `news_symbols` テーブル（作成済み・空）、`connectors/news.ts`、`scoring` の `c_news` / `c_fundamental` 引数 |
| 2 | `chunk()` による銘柄バッチ分割（`packages/core/src/market/batch.ts`）。Queues 化はここを差し替えるだけ |
| 3 / 4 | `MarketDataSource` インターフェース、`symbol_id` の名前空間、`market_calendar` |
| 5 | `packages/core/src/backtest/`（エンジンと統計は実装済み）、`backtest_*` テーブル |
| 6 | R2 の日次スナップショット、`connectors/claude.ts` |
| 7 | `users` / `sessions` / `watchlists` / `user_settings` テーブル（作成済み・未使用） |

---

## Phase 1 の完了条件

- [ ] `npm run typecheck` と `npm test` が通る
- [ ] `npm run check:datasource` が契約プランと項目名を表示する
- [ ] `wrangler dev` でシードデータからダッシュボードが描画される
- [ ] 日次 Cron が 1 回成功し、`/api/health` が当日の日付を返す
- [ ] `docs/DATA-SOURCES.md` のプラン欄が埋まっている

**`docs/DATA-SOURCES.md` の「再配信の可否」が未解決のうちは、
`MEMBER_SIGNUP_ENABLED` を `true` にしない。**
