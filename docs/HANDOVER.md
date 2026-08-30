# 引き継ぎ — このリポジトリだけで再開できるか

別のセッション（あるいは別の人）が、**このリポジトリだけを渡されて**続きを進められるか。
答えは「設計と実装は引き継げる。ただし鍵と外部設定は引き継げない」。
その境目をここに書いておく。

---

## リポジトリだけで分かること

| 知りたいこと | 読む場所 |
|---|---|
| 何を作っているのか / 何を作らないのか | [`README.md`](../README.md) |
| なぜこの構成なのか（3 つの設計判断） | [`ARCHITECTURE.md`](./ARCHITECTURE.md) |
| スコアの配点と算出（**実装より先にこれが正**） | [`SCORING.md`](./SCORING.md) |
| データソースの利用条件・未解決の論点 | [`DATA-SOURCES.md`](./DATA-SOURCES.md) |
| Phase とブランチの対応、継ぎ目 | [`ROADMAP.md`](./ROADMAP.md) |
| デプロイ手順とつまずいたときの切り分け | [`DEPLOY.md`](./DEPLOY.md) |
| LP をデザインするときの仕様 | [`LP-BRIEF.md`](./LP-BRIEF.md) |
| 作業するときの規約 | [`../CLAUDE.md`](../CLAUDE.md) |

コードの側でも、判断の理由はコメントとして残してある。
たとえば「なぜ指標計算を 1 本に絞るのか」は `packages/core` の各所に、
「なぜ銘柄ごとにウィンドウ関数で区切るのか」は `packages/worker/src/db/queries.ts` にある。

**まず動かして確かめられる。** API キーもクラウドのアカウントも要らない。

```bash
npm install
npm test                                    # 136 テスト。ネットワーク不要
npm run db:migrate:local -w @invest/worker
npm run db:seed:local -w @invest/worker
npm run dev                                 # http://localhost:8787/
```

---

## リポジトリでは引き継げないもの

**ここが渡っていないと、コードが読めても本番は動かない。**

| 種別 | 名前 | どこにあるか |
|---|---|---|
| Secret | `JQUANTS_API_KEY` | J-Quants ダッシュボード。Worker には `wrangler secret put` で入れる |
| Secret | `ANTHROPIC_API_KEY` | Phase 1b で使う |
| ID | D1 の `database_id` | `wrangler d1 create` の出力。`wrangler.toml` に貼る（現在は `REPLACE_WITH_D1_DATABASE_ID`） |
| アカウント | Cloudflare のアカウント / ゾーン | どのアカウントにデプロイするか |
| ドメイン | 取得済み | LP `goldencross-incomegains.com` / アプリ `app.goldencross-incomegains.com`。`wrangler.toml` の `[env.production]` に設定済み |
| 設定 | `CF_ACCESS_TEAM_DOMAIN` / `CF_ACCESS_AUD` | Cloudflare Zero Trust のアプリケーション設定 |
| GitHub | `CLOUDFLARE_API_TOKEN` / `CLOUDFLARE_ACCOUNT_ID` | バックフィルの Actions が使う |
| データ | 過去の日足 | D1 の中身。リポジトリには入っていない（`DEPLOY.md` 手順 7 で入れる） |

### 未解決の判断（人が決めるもの）

1. **J-Quants の再配信可否** — 会員制で提供してよいか。
   `DATA-SOURCES.md` の確認欄が空のうちは `MEMBER_SIGNUP_ENABLED` を `true` にしない。
2. **金融商品取引法上の位置づけ** — 投資助言業の登録要否。専門家に確認する。

**この 2 つは会話の中にしか無かったので、`DATA-SOURCES.md` に書き出してある。**
引き継ぎ先はそこを読めば経緯まで分かる。

---

## Claude Design で画面を作る場合

`/design` はデザインキャンバス（複数アートボードを 1 枚のキャンバスに並べ、
公開後にブラウザ上で直接いじれる Artifact）を作る機能。**画面のデザインには使えるが、
ドメインや DNS の設定はしない。** 「ドメイン配下の構成」が何を指すかで分かれる。

### A. 画面の構成・遷移・見た目を設計したい場合 → できる

このリポジトリだけで足りる。デザインに必要な材料が全部入っているため。

| 材料 | 場所 |
|---|---|
| 今ある画面と URL | `packages/worker/src/routes/ui.ts`、`README.md` |
| 画面に出す項目の実体 | `packages/worker/src/types.ts` の `RankingRow` |
| サイト名 | `wrangler.toml` の `SITE_NAME`（正式名）と `SITE_SHORT_NAME`（ヘッダー用） |
| 現在の配色・タイポグラフィ | `packages/worker/src/ui/tokens.ts`（**パレットの唯一の定義**。light / dark 両対応） |
| 画面文言の考え方 | `SCORING.md`（「推奨」ではなく「条件合致」など） |
| 実際の見た目 | `npm run dev` で起動して確認できる |

つまり **架空の画面ではなく、今動いているものを基にデザインできる。**
デザインが固まったら `src/ui/` に反映する、という往復になる。

### B. ドメイン配下の URL 設計（サイトマップ）を決めたい場合 → できる

`/screener`、`/symbol/:id` のような**パス設計**は、
`packages/worker/src/index.ts` のルーティングと `wrangler.toml` の `[[routes]]` に集約してある。
現在の全パスは `README.md` と `DEPLOY.md` から読み取れる。

### C. Cloudflare 側のドメイン・DNS・ルートを設定したい場合 → できない

これは Claude Design ではなく `wrangler.toml` と Cloudflare ダッシュボードの作業。
手順は `DEPLOY.md` の 3 と 5 と 9。**差し替えるのは `wrangler.toml` の
`workers_dev`・`[[routes]]`・`LP_HOSTNAME` / `APP_HOSTNAME` だけ**で済むようにしてある。

### 公開ページ（LP）について

`packages/worker/src/ui/lp.ts` が LP、`src/routes/lp.ts` がその配線。
**デザインの仕様は [`LP-BRIEF.md`](./LP-BRIEF.md) にまとめてある**
（節の役割、書いてはいけない表現、フォームの仕様、差し替えるファイル）。

テンプレートを当てるときに触るのは 2 箇所だけ。

| ファイル | |
|---|---|
| `src/ui/tokens.ts` | 配色。**ここ 1 つで LP とダッシュボードの両方に反映される** |
| `src/ui/lp.ts` の `STYLES` と各節 | LP のレイアウトとマークアップ。**本文はそのまま流用できる** |

`tokens.ts` 以外でパレットを再定義すると `npm test` が落ちる。
LP とダッシュボードで色がずれるのを防ぐため。

### 引き継ぎ先に渡すとよいもの

リポジトリに加えて、次を伝えると初動が速い。

- 独自ドメイン名（決まっていれば）
- 「Phase 1 は Cloudflare Access で社内限定。会員公開は規約確認まで保留」という前提
- 上の「未解決の判断」2 件の状況

---

## 引き継ぎ先が最初にやるとよいこと

```bash
npm install && npm test        # 壊れていないことを確認する
npm run db:seed:local -w @invest/worker && npm run dev   # 画面を見る
```

そのうえで `ARCHITECTURE.md` の「決定的な設計判断」3 つを読む。
ここを踏み外すとバックテストが本番を保証しなくなるので、
**変更を加える前に必ず目を通すこと。**
