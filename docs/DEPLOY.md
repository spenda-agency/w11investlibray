# デプロイ手順と、うまくいかないときの切り分け

---

## 0. その前に

**`docs/DATA-SOURCES.md` の「再配信の可否」が未解決のうちは、
`MEMBER_SIGNUP_ENABLED` を `true` にしないこと。**
Phase 1 は Cloudflare Access で自分 / 社内のみに限定して運用する。

---

## 1. 必要なもの

| | |
|---|---|
| Cloudflare アカウント | **Workers Paid（$5/月）を前提**にしている。無料枠でも日次は回るが、バックフィルで D1 の行数上限に当たる |
| J-Quants の API キー | [J-Quants ダッシュボード](https://jpx-jquants.com/) |
| Node.js 22 以上 | |

> **Windows で作業する場合**
> `wrangler` は必ずリポジトリ内で実行する。ホームディレクトリで走らせると
> `Application Data` の権限エラーになる。

---

## 2. まずローカルで動かす（アカウント不要）

```bash
npm install
npm run typecheck
npm test                                   # ネットワーク不要
npm run db:migrate:local -w @invest/worker
npm run db:seed:local -w @invest/worker
npm run dev
```

`http://localhost:8787/` を開く。サンプルデータなので画面上部に警告が出る。

---

## 3. Cloudflare の資源を作る

```bash
cd packages/worker

npx wrangler d1 create invest-db
# → 出力された database_id を wrangler.toml の [[d1_databases]] に貼る

npx wrangler r2 bucket create invest-snapshots

npm run db:migrate:remote   # 0001 と 0002 を順に適用する
```

---

## 4. Secret を登録する

**`wrangler.toml` に API キーを書かないこと。**

```bash
npx wrangler secret put JQUANTS_API_KEY
# Phase 1b で使う
# npx wrangler secret put ANTHROPIC_API_KEY
```

---

## 5. デプロイする

```bash
npx wrangler deploy
```

ドメインが未確定のうちは `workers_dev = true` のまま `*.workers.dev` で動く。
このとき `/lp` が LP、`/` がダッシュボードになる。

### ドメインが決まったら

**LP とアプリは別ホストにする。** 同じホストでパスだけ分けると、
Access のポリシーをパス単位で書くことになり、ルートを 1 本足しただけで
市場データが公開側に漏れる余地ができる。

1. Cloudflare にゾーンを追加し、DNS に 2 つのレコードを作る
   （Worker のルートに載せるので、内容は proxied な `AAAA ::` か
   ダミーの `A 192.0.2.1` でよい。**必ずプロキシを有効（オレンジ雲）にする**）

   | 名前 | 用途 |
   |---|---|
   | `@`（`example.com`） | LP |
   | `app` | ダッシュボード |

2. `wrangler.toml` を 2 か所直す

   ```toml
   workers_dev = false

   [[routes]]
   pattern = "example.com/*"
   zone_name = "example.com"
   [[routes]]
   pattern = "app.example.com/*"
   zone_name = "example.com"

   [vars]
   LP_HOSTNAME = "example.com"
   APP_HOSTNAME = "app.example.com"
   ```

3. `npx wrangler deploy`

**`LP_HOSTNAME` を空のままルートだけ張らないこと。** ホスト名が未設定だと
`site.ts` がローカル扱いのままになり、LP のホストでもダッシュボードが出る。

### 公開の書き込み口を守る

`POST /api/waitlist` は認証なしで受ける唯一の書き込み口。
コード側でハニーポット・同意必須・日次上限を入れてあるが、
**本気の濫用対策は Cloudflare 側で行う。**

Security → WAF → Rate limiting rules で、
`example.com/api/waitlist` に対して「同一 IP から 10 分あたり 5 リクエスト」
程度の規則を 1 本入れる。

---

## 6. 疎通を確かめる

```bash
export JQUANTS_API_KEY="..."
npm run check:datasource
```

契約プラン・取得可能な範囲・**API が実際に返した項目名**が出る。
結果を `docs/DATA-SOURCES.md` に日付付きで貼ること。

続けて Worker 側:

```bash
BASE_URL=https://your-worker.workers.dev ./scripts/diagnose.sh
```

Windows では `.\scripts\diagnose.ps1`（`.sh` は PowerShell では動かない）。

---

## 7. 過去データを入れる

日次パイプラインは「今日の 1 日ぶん」しか取らない。
指標には過去 300 営業日が要るので、最初に 1 度だけバックフィルする。

```bash
export JQUANTS_API_KEY="..."
npm run backfill -- --from 2024-01-01 --to 2026-08-27 --out out/backfill.sql
cd packages/worker
npx wrangler d1 execute invest-db --remote --file=../../out/backfill.sql
```

GitHub Actions から回すこともできる（`.github/workflows/backfill.yml`）。
`JQUANTS_API_KEY` / `CLOUDFLARE_API_TOKEN` / `CLOUDFLARE_ACCOUNT_ID` を
リポジトリの Secrets に登録しておく。

**Worker ではなくここで回す理由**: 500 銘柄 × 10 年 ≒ 122 万行あり、
取得だけで約 2,450 リクエストになる。Worker の実行時間にも
D1 の 1 日あたりの書き込み上限にも収まらない。

---

## 8. 日次パイプラインを 1 回動かす

```bash
curl -X POST "https://your-worker.workers.dev/api/run-pipeline"
```

`?force=1` で成功済みの日も走り直す。`?date=YYYY-MM-DD` で日付を指定できる。

以降は Cron が平日 19:30 JST（取りこぼしは翌 07:00 JST）に自動で走る。

---

## 9. Cloudflare Access をかける

**ここをやるまで、ダッシュボードはだれでも見られる。**
未設定のうちは画面上部に赤い警告が出るので、消えていることを確認する。

**Access は `app.example.com` にだけ掛ける。** LP 側に掛けると
先行登録が誰にも見えなくなる。

1. Cloudflare ダッシュボード → Zero Trust → Access → Applications
2. Self-hosted アプリケーションを追加し、**アプリ側のホスト**（`app.example.com`）を指定
3. ポリシーで自分のメールアドレスを許可
4. アプリケーションの **Audience (AUD) タグ**をコピー
5. `wrangler.toml` の `CF_ACCESS_TEAM_DOMAIN`（`xxx.cloudflareaccess.com`）と
   `CF_ACCESS_AUD` に設定して再デプロイ

`/api/health` だけは認証を通さない（監視から叩くため）。
内部の数字は返さず、最後に成功した日付と遅れ日数だけを返す。

---

## うまくいかないとき

### LP のホストなのにダッシュボードが出る

`LP_HOSTNAME` が空のまま。手順 5 の 2 を確認する。
`site.ts` はホスト名が未設定だとローカル扱いになり、パスで振り分ける。

### 先行登録が保存されない

`0002_waitlist.sql` が適用されていない。`npm run db:migrate:remote` をやり直す。

```bash
npx wrangler d1 execute invest-db --remote \
  --command "SELECT COUNT(*) FROM waitlist"
```

### 画面に「データがありません」と出る

日次パイプラインが 1 度も成功していない。

```bash
curl "https://your-worker.workers.dev/api/health"
```

`lastSuccessDate` が `null` なら、手順 7 と 8 をやる。

### `/api/run-pipeline` が 400 を返す

`JQUANTS_API_KEY` が未登録。手順 4。

### パイプラインは成功するのにスコアが 0 件

過去データが足りていない。指標が意味を持つ最低 30 営業日ぶんが必要で、
それ未満の銘柄は候補に出さない仕様。手順 7 のバックフィルをやる。

### 「項目 "close" が見つからない」で落ちる

J-Quants の項目名が変わった。`npm run check:datasource` が
**実際に返ってきた項目名**を表示するので、それを
`wrangler.toml` の `JQUANTS_FIELD_ALIASES` に入れる。コードを直さずに復旧できる。

```toml
JQUANTS_FIELD_ALIASES = '{"close":["ClosingPrice"],"volume":["TradedVolume"]}'
```

恒久対応として `packages/worker/src/connectors/jquants.ts` と
`packages/batch/src/jquants.ts` の `FIELD_ALIASES` にも足しておく。

### `/api/health` が `stale` を返す

Cron が動いていないか、途中で失敗している。

```bash
cd packages/worker
npx wrangler tail
npx wrangler d1 execute invest-db --remote \
  --command "SELECT * FROM job_runs ORDER BY target_date DESC LIMIT 5"
```

`job_runs.error` に失敗の理由が残っている。

### `403` が返る

Cloudflare Access のポリシーに自分が入っていないか、`CF_ACCESS_AUD` が
別のアプリケーションのものになっている。手順 9 の 4 をやり直す。

### Windows で `.ps1` の日本語が化ける

BOM が落ちている。UTF-8 BOM 付きで保存し直す。
`npm test` がこれを検査しているので、まずテストを走らせること。
