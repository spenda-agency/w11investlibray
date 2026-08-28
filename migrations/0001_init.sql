-- Phase 1 の初期スキーマ。
--
-- 設計の要点は 3 つ。
--   1. symbol_id は名前空間付き（JP.72030 / US.NVDA / FX.USDJPY）。
--      Phase 3/4 で市場を足すときにスキーマを変えずに済ませる。
--   2. Point-in-Time。財務は disclosed_at、ニュースは published_at で絞れる形にする。
--   3. 上場廃止銘柄を消さない。delisted_at を立てて価格も残す（生存者バイアス対策）。
--
-- このファイルは適用後に編集しない。変更は 0002_*.sql として連番で足す。

-- ============================================================
-- 銘柄マスター
-- ============================================================
CREATE TABLE IF NOT EXISTS symbols (
  symbol_id     TEXT PRIMARY KEY,          -- 'JP.72030'
  market        TEXT NOT NULL,             -- 'JP' | 'US' | 'FX'
  code          TEXT NOT NULL,             -- '72030'（市場内のコード）
  name          TEXT NOT NULL,
  name_en       TEXT,
  sector33      TEXT,
  sector17      TEXT,
  currency      TEXT NOT NULL DEFAULT 'JPY',
  listed_at     TEXT,                      -- 'YYYY-MM-DD'
  -- 上場廃止日。NULL なら現在も上場中。
  -- **廃止された銘柄の行を削除しないこと。** 削除するとバックテストが
  -- 「生き残った銘柄だけ」を対象にしてしまい、成績が実態より良く出る。
  delisted_at   TEXT,
  updated_at    TEXT NOT NULL,
  UNIQUE (market, code)
);
CREATE INDEX IF NOT EXISTS idx_symbols_market_listed ON symbols (market, delisted_at);
CREATE INDEX IF NOT EXISTS idx_symbols_sector ON symbols (sector33);

-- ============================================================
-- 営業日カレンダー
-- ============================================================
-- 営業日の判定を「土日以外」で推測しない。祝日・臨時休場・半日立会は
-- 市場ごとに違い、推測すると指標の本数がズレる。
CREATE TABLE IF NOT EXISTS market_calendar (
  market   TEXT NOT NULL,
  date     TEXT NOT NULL,                  -- 'YYYY-MM-DD'
  is_open  INTEGER NOT NULL,               -- 0 | 1
  PRIMARY KEY (market, date)
);

-- ============================================================
-- 日足
-- ============================================================
-- 分割調整前の生値を保存する。調整は読み出し時に applySplitAdjustment で行う。
-- 調整後の値だけを保存すると、後から分割が起きたときに過去行を全部
-- 書き換えることになり、いつの時点の調整なのか分からなくなる。
CREATE TABLE IF NOT EXISTS prices_daily (
  symbol_id          TEXT NOT NULL,
  date               TEXT NOT NULL,
  open               REAL NOT NULL,
  high               REAL NOT NULL,
  low                REAL NOT NULL,
  close              REAL NOT NULL,
  volume             REAL NOT NULL,
  turnover           REAL,                 -- 売買代金
  adjustment_factor  REAL NOT NULL DEFAULT 1.0,
  PRIMARY KEY (symbol_id, date),
  FOREIGN KEY (symbol_id) REFERENCES symbols (symbol_id)
);
CREATE INDEX IF NOT EXISTS idx_prices_date ON prices_daily (date);

-- ============================================================
-- テクニカル指標
-- ============================================================
CREATE TABLE IF NOT EXISTS indicators_daily (
  symbol_id     TEXT NOT NULL,
  date          TEXT NOT NULL,
  rsi14         REAL,
  macd          REAL,
  macd_signal   REAL,
  macd_hist     REAL,
  sma5          REAL,
  sma25         REAL,
  sma75         REAL,
  sma200        REAL,
  atr14         REAL,
  vol_sma20     REAL,
  vol_ratio     REAL,
  ret20         REAL,
  ret60         REAL,
  hi52          REAL,
  lo52          REAL,
  PRIMARY KEY (symbol_id, date),
  FOREIGN KEY (symbol_id) REFERENCES symbols (symbol_id)
);
CREATE INDEX IF NOT EXISTS idx_indicators_date ON indicators_daily (date);

-- ============================================================
-- シグナル
-- ============================================================
-- strength は「重ねた条件のうち何個に合致したか」。
-- 単純なクロスと、トレンド転換を伴うクロスを区別するために持つ。
CREATE TABLE IF NOT EXISTS signals_daily (
  symbol_id    TEXT NOT NULL,
  date         TEXT NOT NULL,
  signal_code  TEXT NOT NULL,              -- 'golden_cross' | 'exit'
  strength     INTEGER NOT NULL,
  detail       TEXT,                       -- JSON。合致した条件名の配列
  PRIMARY KEY (symbol_id, date, signal_code),
  FOREIGN KEY (symbol_id) REFERENCES symbols (symbol_id)
);
CREATE INDEX IF NOT EXISTS idx_signals_date_code ON signals_daily (date, signal_code, strength);

-- ============================================================
-- スコア
-- ============================================================
-- score_version を必ず持つ。配点が変わったときに過去のスコアを
-- 黙って書き換えないため（docs/SCORING.md 参照）。
-- 欠損項目は 0 ではなく NULL。「ニュースが無い」と「悪材料がある」は違う。
CREATE TABLE IF NOT EXISTS scores_daily (
  symbol_id      TEXT NOT NULL,
  date           TEXT NOT NULL,
  score_version  TEXT NOT NULL,
  total          INTEGER,
  c_trend        INTEGER,
  c_rsi          INTEGER,
  c_macd         INTEGER,
  c_ma           INTEGER,
  c_volume       INTEGER,
  c_momentum     INTEGER,
  c_fundamental  INTEGER,
  c_news         INTEGER,
  verdict        TEXT NOT NULL,            -- BUY_NOW | BUY_WATCH | WATCH | AVOID
  entry_px       REAL,
  stop_px        REAL,
  target_px      REAL,
  rr             REAL,
  PRIMARY KEY (symbol_id, date, score_version),
  FOREIGN KEY (symbol_id) REFERENCES symbols (symbol_id)
);
CREATE INDEX IF NOT EXISTS idx_scores_ranking ON scores_daily (date, score_version, total DESC);
CREATE INDEX IF NOT EXISTS idx_scores_verdict ON scores_daily (date, verdict, total DESC);

-- ============================================================
-- ファンダメンタル（Phase 1b）
-- ============================================================
-- **disclosed_at が主キーの一部**であることが point-in-time の要。
-- fiscal_period で引くと、まだ公表されていない決算を使ってしまう。
CREATE TABLE IF NOT EXISTS fundamentals (
  symbol_id      TEXT NOT NULL,
  disclosed_at   TEXT NOT NULL,            -- 'YYYY-MM-DD'（公表日）
  fiscal_period  TEXT NOT NULL,            -- '2026Q1' など（表示用。絞り込みには使わない）
  net_sales      REAL,
  operating_income REAL,
  ordinary_income  REAL,
  net_income     REAL,
  eps            REAL,
  bps            REAL,
  forecast_net_sales REAL,
  forecast_net_income REAL,
  raw            TEXT,                     -- JSON。取得元の生データ
  PRIMARY KEY (symbol_id, disclosed_at, fiscal_period),
  FOREIGN KEY (symbol_id) REFERENCES symbols (symbol_id)
);
CREATE INDEX IF NOT EXISTS idx_fundamentals_disclosed ON fundamentals (disclosed_at);

-- ============================================================
-- ニュース（Phase 1b）
-- ============================================================
-- 原文は R2 に置き、ここには参照キーだけを持つ。
-- 画面に出すのはタイトル・出典リンク・自作要約のみ（docs/DATA-SOURCES.md）。
CREATE TABLE IF NOT EXISTS news (
  news_id       TEXT PRIMARY KEY,
  published_at  TEXT NOT NULL,             -- ISO8601。point-in-time の基準
  source        TEXT NOT NULL,
  url           TEXT NOT NULL,
  title         TEXT NOT NULL,
  lang          TEXT NOT NULL DEFAULT 'ja',
  r2_key        TEXT,
  fetched_at    TEXT NOT NULL,
  UNIQUE (url)
);
CREATE INDEX IF NOT EXISTS idx_news_published ON news (published_at DESC);

CREATE TABLE IF NOT EXISTS news_symbols (
  news_id      TEXT NOT NULL,
  symbol_id    TEXT NOT NULL,
  importance   TEXT NOT NULL,              -- 'S' | 'A' | 'B' | 'C'
  sentiment    REAL,                       -- -1.0 〜 +1.0
  relevance    REAL,                       -- 0.0 〜 1.0
  summary      TEXT,
  model        TEXT,                       -- 分析に使ったモデル
  analyzed_at  TEXT NOT NULL,
  PRIMARY KEY (news_id, symbol_id),
  FOREIGN KEY (news_id) REFERENCES news (news_id),
  FOREIGN KEY (symbol_id) REFERENCES symbols (symbol_id)
);
CREATE INDEX IF NOT EXISTS idx_news_symbols_lookup ON news_symbols (symbol_id, importance);

-- ============================================================
-- バックテスト（Phase 5。結果は GitHub Actions から投入する）
-- ============================================================
CREATE TABLE IF NOT EXISTS backtest_runs (
  run_id      TEXT PRIMARY KEY,
  rule_id     TEXT NOT NULL,
  params      TEXT,                        -- JSON
  universe    TEXT NOT NULL,               -- 'JP500' など
  date_from   TEXT NOT NULL,
  date_to     TEXT NOT NULL,
  created_at  TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS backtest_trades (
  run_id       TEXT NOT NULL,
  symbol_id    TEXT NOT NULL,
  entry_date   TEXT NOT NULL,
  entry_px     REAL NOT NULL,
  exit_date    TEXT NOT NULL,
  exit_px      REAL NOT NULL,
  pnl_pct      REAL NOT NULL,
  exit_reason  TEXT NOT NULL,
  bars_held    INTEGER NOT NULL,
  PRIMARY KEY (run_id, symbol_id, entry_date),
  FOREIGN KEY (run_id) REFERENCES backtest_runs (run_id)
);

CREATE TABLE IF NOT EXISTS backtest_stats (
  run_id         TEXT PRIMARY KEY,
  trades         INTEGER NOT NULL,
  win_rate       REAL,
  avg_win        REAL,
  avg_loss       REAL,
  profit_factor  REAL,
  expectancy     REAL,
  max_drawdown   REAL,
  sharpe         REAL,
  total_return   REAL,
  avg_bars_held  REAL,
  FOREIGN KEY (run_id) REFERENCES backtest_runs (run_id)
);

-- ============================================================
-- 会員機能（Phase 7）— **Phase 1 では作るだけで使わない**
-- ============================================================
-- 市場データを登録ユーザーへ提供することが契約上の「第三者提供」に
-- 当たるかを確認するまで、MEMBER_SIGNUP_ENABLED を true にしない。
-- 詳細は docs/DATA-SOURCES.md の「再配信の可否」。
CREATE TABLE IF NOT EXISTS users (
  user_id     TEXT PRIMARY KEY,
  email       TEXT NOT NULL UNIQUE,
  created_at  TEXT NOT NULL,
  status      TEXT NOT NULL DEFAULT 'active'
);

CREATE TABLE IF NOT EXISTS sessions (
  session_id  TEXT PRIMARY KEY,
  user_id     TEXT NOT NULL,
  created_at  TEXT NOT NULL,
  expires_at  TEXT NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users (user_id)
);
CREATE INDEX IF NOT EXISTS idx_sessions_user ON sessions (user_id, expires_at);

CREATE TABLE IF NOT EXISTS user_settings (
  user_id            TEXT PRIMARY KEY,
  horizon_days       INTEGER,
  risk_level         TEXT,
  max_position_pct   REAL,
  stop_loss_pct      REAL,
  take_profit_pct    REAL,
  allocation         TEXT,                 -- JSON
  updated_at         TEXT NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users (user_id)
);

CREATE TABLE IF NOT EXISTS watchlists (
  user_id    TEXT NOT NULL,
  symbol_id  TEXT NOT NULL,
  added_at   TEXT NOT NULL,
  note       TEXT,
  PRIMARY KEY (user_id, symbol_id),
  FOREIGN KEY (user_id) REFERENCES users (user_id),
  FOREIGN KEY (symbol_id) REFERENCES symbols (symbol_id)
);

-- ============================================================
-- ジョブ実行の記録
-- ============================================================
-- 冪等性と監視の両方に使う。再実行時に「もう終わっている日」を飛ばし、
-- /api/health が最後に成功した日を返せるようにする。
CREATE TABLE IF NOT EXISTS job_runs (
  job          TEXT NOT NULL,              -- 'daily_pipeline' | 'fetch_prices' など
  target_date  TEXT NOT NULL,
  status       TEXT NOT NULL,              -- 'running' | 'ok' | 'error'
  started_at   TEXT NOT NULL,
  finished_at  TEXT,
  rows_written INTEGER,
  error        TEXT,
  PRIMARY KEY (job, target_date)
);
CREATE INDEX IF NOT EXISTS idx_job_runs_status ON job_runs (job, status, target_date DESC);
