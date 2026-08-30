-- 先行登録（LP のメール取得）。
--
-- 適用済みの 0001 は編集しない。連番で足す（CLAUDE.md）。
--
-- 個人情報を持つ唯一のテーブル。設計方針は 3 つ。
--   1. **生の IP を保存しない。** 濫用対策には日次の上限で足りる
--   2. 同意した時刻を必ず残す（特定電子メール法。同意の記録が要る）
--   3. 解除は行を消さずに status で表す。消すと再登録の抑止ができない

CREATE TABLE IF NOT EXISTS waitlist (
  email         TEXT PRIMARY KEY,     -- 小文字に正規化して保存する
  created_at    TEXT NOT NULL,        -- ISO8601
  consented_at  TEXT NOT NULL,        -- 同意チェックを付けた時刻
  source        TEXT,                 -- 'lp' など。流入元の識別
  locale        TEXT,
  status        TEXT NOT NULL DEFAULT 'pending',  -- pending | confirmed | unsubscribed
  note          TEXT
);
CREATE INDEX IF NOT EXISTS idx_waitlist_created ON waitlist (created_at DESC);
CREATE INDEX IF NOT EXISTS idx_waitlist_status ON waitlist (status);
