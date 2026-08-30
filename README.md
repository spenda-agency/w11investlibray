# w11investlibray — AI投資リサーチ基盤

5,000 銘柄を毎日機械的にスクリーニングし、売買判断に必要な情報を 1 画面に集約する
**投資判断支援システム**。Cloudflare Workers + D1 上で動く。

朝にダッシュボードを開くと、その日の候補がスコア付きで並ぶ。

```
本日の候補 TOP10
  1  ソニーグループ      82   RSI 58  MACD強気  25日線↑  出来高+82%
  2  トヨタ自動車        79   RSI 61  MACD強気  25日線↑  出来高+31%
  ...
```

銘柄を開くと、スコアの内訳・指標・エントリー / 損切り / 利確の条件まで見える。

---

## これは何ではないか

**「上がる銘柄を当てる AI」ではない。**

このシステムがやるのは、5,000 銘柄について毎日同じ計算を回し、
**過去データで検証できるルールに合致した候補を機械的に抽出する**ことだけ。
AI（Claude）の役割はニュースの分類・要約・説明であって、株価の予測ではない。

そのため設計上、次を守っている。

| | |
|---|---|
| 指標計算 | 完全にプログラム。AI を使わない |
| 未来情報の混入 | スキーマで防ぐ（`disclosed_at` / `published_at` で絞る） |
| 生存者バイアス | 上場廃止銘柄も残す |
| スコアの意味 | 「条件への合致度」。期待リターンではない |

詳細は [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md)。

---

## 構成

```
packages/core     依存ゼロの純TypeScript。指標・シグナル・スコア・バックテスト
packages/worker   Cloudflare Worker。取得・保存・API・画面・日次Cron・公開LP
packages/batch    Node CLI。バックフィルとバックテスト（GitHub Actions から）
migrations/       D1 スキーマ
docs/             設計・スコア定義・データソースの利用条件
```

公開する面は 2 つに分かれている。

| ホスト | 中身 | 認証 |
|---|---|---|
| `example.com` | LP（サービス紹介と先行登録） | なし。市場データを一切返さない |
| `app.example.com` | ダッシュボード | Cloudflare Access |

ローカルでは `/lp` が LP、`/` がダッシュボード。

**指標の計算コードは `packages/core` の 1 本しかない。**
日次パイプライン（Workers）とバックテスト（Node）が同じコードを呼ぶので、
バックテストの結果が本番の挙動をそのまま表す。

---

## セットアップ

```bash
npm install
npm run typecheck
npm test              # ネットワーク不要
```

### データソースの疎通確認

```bash
export JQUANTS_API_KEY="..."      # https://jpx-jquants.com/ で取得
npm run check:datasource
```

契約プラン・取得可能な期間・**API が実際に返した項目名**を表示する。
結果は [`docs/DATA-SOURCES.md`](docs/DATA-SOURCES.md) に記録すること。

### ローカルで動かす

```bash
npm run db:migrate:local     # ローカル D1 にスキーマを適用
npm run db:seed:local        # 固定のサンプルデータを入れる
npm run dev                  # http://localhost:8787/
```

`db:seed:local` は合成データで、本物の市場データではない。
画面上部に「サンプルデータです」の警告が出る。

### デプロイ

[`docs/DEPLOY.md`](docs/DEPLOY.md) を参照。

---

## 現在の状態

**Phase 1**（日本株 約 500 銘柄・日足・テクニカル指標・スコアリング・画面）。

Phase ごとの範囲とブランチは [`docs/ROADMAP.md`](docs/ROADMAP.md)。
別のセッションや人に引き継ぐときは [`docs/HANDOVER.md`](docs/HANDOVER.md)
（リポジトリで渡るもの / 渡らないもの）。
LP をデザインするときは [`docs/LP-BRIEF.md`](docs/LP-BRIEF.md)。

### 公開範囲について

現在は **Cloudflare Access の背後で自分 / 社内のみ**が見る構成。
会員制のテーブルとルーティングは実装済みだが `MEMBER_SIGNUP_ENABLED = "false"` で閉じている。

理由は [`docs/DATA-SOURCES.md`](docs/DATA-SOURCES.md) の「再配信の可否」節にある。
市場データを登録ユーザーへ提供することが契約上の「第三者提供」に当たるかを
確認するまで、ここは開けない。

---

## 免責

本システムは情報提供および投資判断の支援を目的としたものであり、
特定の銘柄の売買を勧誘するものではない。**投資判断は利用者自身の責任で行うこと。**

スコアおよびシグナルは、過去データに基づく機械的な計算結果であり、
将来の価格や収益を保証するものではない。

各データソースの利用は、それぞれの提供元の利用規約に従うこと。
