# アーキテクチャ

```
  GitHub Actions                         Cloudflare
  （重い・たまに走る）                    （軽い・毎日走る）

  ┌────────────────────┐               ┌──────────────────────────────┐
  │ backfill           │               │ Cron 19:30 JST (平日)        │
  │  10年分の日足取得   │               │        │                     │
  │        ↓           │  SQL / Import │        ▼                     │
  │  SQL 生成          │──────────────▶│ daily-pipeline               │
  │                    │               │  ① J-Quants 日足取得         │
  │ backtest           │               │  ② 指標計算 (packages/core)  │
  │  ルール検証         │──────────────▶│  ③ シグナル判定              │
  │  → backtest_*      │  結果のみ投入  │  ④ スコアリング              │
  └─────────┬──────────┘               │  ⑤ ニュース分析 (Phase 1b)   │
            │                          │  ⑥ R2 へスナップショット      │
            │ 同じコードを使う           └──────────────┬───────────────┘
            ▼                                           │
     ┌──────────────────┐                               ▼
     │ packages/core    │◀──────────── D1 (INVEST_DB) / R2 (INVEST_R2)
     │  依存ゼロの純TS   │                               │
     │  指標/シグナル/    │                               ▼
     │  スコア/バックテスト│           Worker: API + SSR画面 + Cloudflare Access
     └──────────────────┘                               │
                                                        ▼
                                                 Web ダッシュボード
```

---

## 決定的な設計判断

### ① 指標計算のコードは 1 本しか持たない

`packages/core` は **依存ゼロの純 TypeScript**。
Cloudflare Workers（日次）と Node（GitHub Actions のバックテスト）の**両方が同じコードを呼ぶ**。

実行環境が 2 つあるからといって「日次は TypeScript、バックテストは Python」にすると、
RSI / MACD / ゴールデンクロス判定が**必ず少しずつズレる**。
そうなるとバックテスト結果が本番の挙動を保証しなくなり、
このシステムの価値（検証可能性）そのものが失われる。

そのため `packages/core` には次の制約を課す。

- **依存パッケージを追加しない**（`package.json` の `dependencies` は空のまま）
- `fetch` / `D1` / `fs` / `process` を参照しない。**入力は配列、出力は配列**
- 乱数と現在時刻を使わない。同じ入力からは常に同じ出力が出る

### ② Point-in-Time をスキーマで強制する

Look-ahead bias と Survivorship bias は「気をつける」では防げない。

| バイアス | 防ぎ方 |
|---|---|
| Look-ahead（未来情報の混入） | 財務は `disclosed_at`、ニュースは `published_at` で絞る。`fiscal_period` では絞らない |
| 同日約定 | バックテストは「Day t の終値までの情報 → Day t+1 の**始値**で約定」。同日終値約定は `packages/core/src/backtest/engine.ts` が例外を投げる |
| Survivorship（生存者バイアス） | **上場廃止銘柄を `symbols` から消さない。** `delisted_at` を立てて価格も残す |

### ③ スコアは `score_version` で世代管理する

Phase 1 は `c_fundamental` / `c_news` が埋まらない。
欠損項目を 0 点にすると「ニュースが無い銘柄」が「悪材料のある銘柄」と同じになるため、
**埋まっている項目だけで正規化**し、その事実を `score_version` に刻む。

詳細は [`SCORING.md`](./SCORING.md)。

---

## LP とアプリをホストで分ける

```
example.com       LP（公開）           市場データを一切返さない
app.example.com   ダッシュボード        Cloudflare Access の後ろ
```

**同じホストでパスだけ分けない。** パスで分けると Access のポリシーも
パス単位で書くことになり、ルートを 1 本足しただけで市場データが
公開側に漏れる余地ができる。ホストが違えば Access の適用範囲も
ホスト単位で済み、事故の形が「設定漏れ」ではなく「そもそも届かない」になる。

判定は `packages/worker/src/site.ts` の 1 箇所。
`LP_HOSTNAME` / `APP_HOSTNAME` が未設定のとき（ローカルや workers.dev）は
`/lp` 配下を LP、それ以外をアプリとして扱う。
**未知のホストはアプリ側に落とす** — 公開側を広げる方向に倒さない。

LP から市場データに触れる経路は作らないこと。LP 側が D1 に触るのは
先行登録の書き込み（`waitlist` テーブル）だけ。

---

## パッケージの責務

| パッケージ | 依存 | 責務 |
|---|---|---|
| `@invest/core` | なし | 計算だけ。I/O を持たない |
| `@invest/worker` | `@invest/core` | Cloudflare 上の I/O 全部（J-Quants 取得・D1・R2・HTTP・画面） |
| `@invest/batch` | `@invest/core` | Node 上の重い処理（バックフィル・バックテスト・疎通確認） |

`@invest/worker` と `@invest/batch` は**互いに依存しない**。
共有したくなったものは `@invest/core` に上げるか、重複を許容する。

---

## 市場を足すときの継ぎ目

Phase 3（米国株）/ Phase 4（FX）でスキーマを変えずに済むよう、
Phase 1 の時点で以下を用意してある。

- `symbol_id` は名前空間付き（`JP.7203` / `US.NVDA` / `FX.USDJPY`）
- `market_calendar` テーブルで市場ごとの営業日を持つ
- `MarketDataSource` インターフェース（`packages/core/src/market/source.ts`）

Phase 3 でやることは、**`MarketDataSource` を実装して `market_calendar` を埋めるだけ**。

---

## Cloudflare のリソース

| バインディング | 種別 | 用途 |
|---|---|---|
| `INVEST_DB` | D1 | 銘柄・価格・指標・シグナル・スコア |
| `INVEST_R2` | R2 | 日次スナップショット JSON、（Phase 1b）ニュース原文 |

**Phase 1 では Queues と Vectorize を入れない。**
500 銘柄は 1 回の Cron 実行で捌ける。Queues は 4,000 銘柄になる Phase 2 で足す。
Vectorize が要るのは RAG を作る Phase 6。
