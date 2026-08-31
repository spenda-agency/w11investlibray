# 公開までの手順

**上から順にやれば公開できる。** どの画面で何を入力するかまで書いてある。

コマンドの意味や、詰まったときの切り分けは [`DEPLOY.md`](./DEPLOY.md) を引く。
こちらは順路、あちらは辞書。

---

## 全体像

作業は 3 本に分かれる。**A だけ終われば LP は公開できる**（＝先行登録の受付を開始できる）。
B はダッシュボードを動かす作業で、A の後でよい。C は急がない。

```
A. LP を公開する           ← ここまでで先行登録の受付が始まる
      ↓
B. ダッシュボードを動かす   ← 自分だけが見る画面
      ↓
C. 会員公開の判断           ← J-Quants の回答待ち。数か月かかってもよい
```

### 順序で 1 箇所だけ、間違えると面倒になるところ

**Cloudflare Access（B5）は、手動パイプライン（B4）の後に掛ける。**

Access は Worker の**手前**（Cloudflare のエッジ）で止める仕組みなので、
掛けた瞬間から `curl` でアプリ側の URL を叩けなくなる。
先に掛けてしまうと、初回のパイプラインを手で回す方法が無くなる。

Cron（平日 19:30）は HTTP のエッジを通らず Worker を直接起動するので、
**Access の影響を受けない。** 一度手で回しておけば、あとは自動で回る。

---

## チェックリスト

```
トラック A — LP を公開する
  [ ] A1  wrangler にログインする
  [ ] A2  D1 を作り、database_id を wrangler.toml の 2 箇所に貼る
  [ ] A3  R2 バケットを作る
  [ ] A4  マイグレーションを本番の D1 に流す
  [ ] A5  運営者名・所在地・連絡先を書く   ← これを埋めるまで公開しない
  [ ] A6  preflight を通してデプロイする
  [ ] A7  ドメインで開けることを確認する
  [ ] A8  WAF のレート制限を 1 本入れる
  [ ] A9  自分で先行登録して、保存されることを確認する

トラック B — ダッシュボードを動かす
  [ ] B1  J-Quants の API キーを Secret に登録する（--env production！）
  [ ] B2  疎通を確認し、プラン情報を DATA-SOURCES.md に記録する
  [ ] B3  過去データを入れる（バックフィル）
  [ ] B4  日次パイプラインを手で 1 回回す       ← Access より前
  [ ] B5  Cloudflare Access を app ホストにだけ掛ける
  [ ] B6  Team domain と AUD を wrangler.toml に貼って再デプロイ
  [ ] B7  画面上部の赤い警告が消えたことを確認する

トラック C — 会員公開の判断
  [ ] C1  J-Quants に再配信の可否を問い合わせる
  [ ] C2  回答を DATA-SOURCES.md に記録する
  [ ] C3  可なら MEMBER_SIGNUP_ENABLED を true にする
```

---

# トラック A — LP を公開する

## A1. wrangler にログインする

```bash
cd packages/worker
npx wrangler login
```

ブラウザが開いて Cloudflare の認証に飛ぶ。許可すると端末に戻る。

```bash
npx wrangler whoami      # アカウントが合っているか確認
```

**ドメインを置いているアカウントでログインすること。** 別アカウントだと
デプロイは通るのにルートが一致せず、ドメインが 404 になる。

> **Windows の場合**: `wrangler` は必ずリポジトリの中で実行する。
> ホームディレクトリで走らせると `Application Data` の権限エラーになる。

---

## A2. D1 を作り、`database_id` を 2 箇所に貼る

```bash
npx wrangler d1 create invest-db
```

こういう出力が返る。

```
✅ Successfully created DB 'invest-db'

[[d1_databases]]
binding = "INVEST_DB"
database_name = "invest-db"
database_id = "a1b2c3d4-5e6f-7890-abcd-ef1234567890"
```

**`database_id` の値を `packages/worker/wrangler.toml` の 2 箇所に貼る。**

| 行 | 場所 | 何に使われるか |
|---|---|---|
| 31 行目付近 | `[[d1_databases]]` | `wrangler dev` / `db:migrate:local` |
| 103 行目付近 | `[[env.production.d1_databases]]` | **本番** |

どちらも `REPLACE_WITH_D1_DATABASE_ID` になっているので、同じ値で置き換える。

> **`preflight` が見ているのは本番側だけ。** 既定側を忘れても止まらないが、
> ローカルで動かすときに困る。両方入れておくこと。

---

## A3. R2 バケットを作る

```bash
npx wrangler r2 bucket create invest-snapshots
```

Phase 1 ではまだ中身を使わないが、バインディングが解決できないと
デプロイが失敗するので先に作る。

---

## A4. マイグレーションを本番の D1 に流す

```bash
cd /path/to/w11investlibray
npm run db:migrate:remote -w @invest/worker
```

`0001_init.sql`（17 テーブル）と `0002_waitlist.sql`（先行登録）が順に適用される。
このスクリプトには `--env production` が入っているので、本番の D1 を指す。

確認:

```bash
cd packages/worker
npx wrangler d1 execute invest-db --remote --env production \
  --command "SELECT name FROM sqlite_master WHERE type='table' ORDER BY name"
```

`waitlist` が一覧にあること。無ければ `0002` が流れていない。

---

## A5. 運営者名・所在地・連絡先を書く ← **これを埋めるまで公開しない**

LP は公開した瞬間からメールアドレスを集め始める。
**誰が集めているのかが分からない状態で集めてはいけない。**

角括弧が残っているのは **2 行だけ**。

### ① プライバシーポリシー

`packages/worker/src/routes/lp.ts` の `privacyPage()` の中：

```
[運営者名・所在地・連絡先を記入
 — 法人なら商号と本店所在地、個人事業なら屋号と氏名。
 連絡先はメールアドレスで足ります]
```

`<span class="todo">…</span>` ごと、書いた内容に置き換える。書き方の例:

```html
<p>スペンダ株式会社<br>
東京都〇〇区〇〇 1-2-3<br>
お問い合わせ: privacy@example.com</p>
```

### ② LP のフッター

`packages/worker/src/ui/lp.ts` の `.copyright` の行：

```
運営: [運営者名を記入 — 法人なら商号、個人事業なら屋号と氏名]
 ／ お問い合わせ: [連絡先を記入 — メールアドレスで可]
```

### 埋め終わったかの確認

```bash
grep -rn 'を記入' packages/worker/src/
```

**何も出なければ完了。** 1 件でも残っていれば公開しない。

> **保存期間と解除方法は文案を入れてある。** いまのコードが実際に
> やっていることに合わせた文面なので、そのままで筋が通っている。
> ただし**運用を変えたら直すこと**——たとえば解除リンクを付けずに
> 配信を始めるなら、「メールに記載の解除方法」という記述が嘘になる。
>
> 個人情報保護法上、取得する主体の名称と連絡先は本人が知り得る状態に
> 置く必要がある。**最終的な判断は事業者側で確認すること。**
> ここに書いてあるのは実装上の所在であって、法務のお墨付きではない。

---

## A6. preflight を通してデプロイする

```bash
npm run preflight
```

`✓ デプロイ前チェック通過（警告 1 件）` になれば進んでよい。
警告は「Access が未設定」で、これは B5 で消える。**止める必要はない。**

まだ `✗` が出るなら、そこに直し方が書いてある。

```bash
npm run deploy
```

これは `preflight` → `wrangler deploy --env production` の順に走る。
**`--env production` が要る**（付け忘れるとルートの無い Worker が上がり、
ドメインに反応しない）。`npm run deploy` を使っていれば自動で付く。

---

## A7. ドメインで開けることを確認する

DNS の A レコードは設定済みのはず（`@` と `app`、どちらも
IPv4 `192.0.2.1`、**プロキシ オン**）。まだなら `DEPLOY.md` の手順 5 を見る。

```bash
curl -sI https://goldencross-incomegains.com/ | grep -iE 'HTTP/|cf-ray'
```

| 見えるもの | 意味 |
|---|---|
| `cf-ray:` がある | Cloudflare のエッジを通っている |
| `HTTP/2 200` | Worker が応答している |
| `HTTP/2 522` / `523` | **プロキシが灰色雲になっている。** オレンジ雲に直す |
| 名前が引けない | DNS レコードが無い |

ブラウザで `https://goldencross-incomegains.com/` を開いて、LP が出ることを確認する。

CSP と書体も見ておく:

```bash
curl -sI https://goldencross-incomegains.com/ | grep -i content-security-policy
```

`fonts.googleapis.com` と `fonts.gstatic.com` が入っていること
（Noto Sans JP はこの 2 つから読んでいる。無いと書体が黙って落ちる）。

---

## A8. WAF のレート制限を 1 本入れる

`POST /api/waitlist` は**認証なしで受ける唯一の書き込み口**。
コード側にハニーポット・同意必須・1 日 500 件の上限は入れてあるが、
それは最後の砦であって、入口で削るのは Cloudflare 側の仕事。

### 画面の場所

```
dash.cloudflare.com
  → goldencross-incomegains.com を選ぶ
  → 左メニュー Security → WAF
  → Rate limiting rules タブ
  → Create rule
```

### 入力する値

| 欄 | 入れる値 |
|---|---|
| Rule name | `waitlist-abuse` |
| **If incoming requests match** | Field `URI Path` / Operator `equals` / Value `/api/waitlist` |
| （＋ And で 1 行足す） | Field `Request Method` / Operator `equals` / Value `POST` |
| **With the same characteristics as** | `IP` |
| **When rate exceeds** — Requests | `5` |
| **When rate exceeds** — Period | `10 minutes` |
| **Then take action** | `Block` |
| Duration | `1 hour` |

Deploy を押す。

> **Period の選択肢はプランで変わる。** Free プランでは `10 seconds` と
> `1 minute` しか出ないことがある。その場合は
> **`1 minute` あたり `3` リクエスト**にする。趣旨は同じ。

### なぜ Method も見るのか

`GET /api/waitlist` は 405 を返すだけで、D1 に触らない。
Method を絞らないと、無害な GET でも枠を消費して、
正規の利用者の POST が巻き添えでブロックされる。

---

## A9. 自分で先行登録して、保存されることを確認する

ブラウザで LP を開き、自分のメールアドレスで実際に登録する。
**同意チェックを入れないと送信できない**ことも確認する（必須にしてある）。

D1 に入ったかを見る:

```bash
cd packages/worker
npx wrangler d1 execute invest-db --remote --env production \
  --command "SELECT email, created_at, consented_at, status FROM waitlist"
```

| 見るところ | 期待 |
|---|---|
| `email` | **小文字**で入っている（正規化している） |
| `consented_at` | 空でない（同意した時刻） |
| `status` | `pending` |
| IP アドレス | **列が無い。** そもそも保存していない |

**ここまでで LP は公開できる状態。** 告知して構わない。

---

# トラック B — ダッシュボードを動かす

## B1. J-Quants の API キーを Secret に登録する

```bash
cd packages/worker
npx wrangler secret put JQUANTS_API_KEY --env production
# → プロンプトが出るのでキーを貼って Enter
```

### **`--env production` を落とさないこと**

ここが一番ハマる。`wrangler.toml` は `name = "w11-invest-library"` に
`[env.production]` を足した構成で、`[env.production]` に `name` の上書きが無い。
そのため `wrangler deploy --env production` が上げる Worker の名前は
**`w11-invest-library-production`**（環境名が接尾辞として付く）。

**Secret は Worker ごとに分かれている。** `--env` を付けずに登録すると
`w11-invest-library`——誰も使っていないほう——に入る。

症状が分かりにくい。**デプロイは成功するのに、パイプラインだけが
`JQUANTS_API_KEY が未設定` で落ち続ける。**

```bash
npx wrangler secret list --env production
```

`JQUANTS_API_KEY` が出ること。空なら、これ。

**`wrangler.toml` に API キーを書かないこと。** git に入る。

---

## B2. 疎通を確認し、プラン情報を記録する

```bash
cd /path/to/w11investlibray
export JQUANTS_API_KEY="..."        # Windows: $env:JQUANTS_API_KEY="..."
npm run check:datasource
```

> **B1 で登録したのとは別物。** B1 の Secret は Cloudflare 上の Worker が
> 使うもので、手元の端末からは読めない。このコマンドは手元で走るので、
> 環境変数として渡す必要がある。**同じキーを 2 か所に置くことになる。**

契約プラン・取得できる期間・遅延・**API が実際に返した項目名**が出る。

出力を `docs/DATA-SOURCES.md` の §1 にある空欄に貼る:

```
確認日:            2026-XX-XX
プラン:            （出力から）
日足の遅延:        （出力から）
取得可能な期間:    （出力から）
```

**取得可能な期間は B3 のバックフィル範囲を決める。** プランによっては
10 年遡れず、`--from` を後ろにずらす必要がある。

> 項目名が変わっていて「項目 "close" が見つからない」で落ちた場合、
> このコマンドが**実際に返ってきた名前**を表示する。それを
> `wrangler.toml` の `JQUANTS_FIELD_ALIASES` に入れればコードを直さず復旧できる。
> 書き方は `DEPLOY.md` の「うまくいかないとき」にある。

---

## B3. 過去データを入れる（バックフィル）

日次パイプラインは「今日の 1 日ぶん」しか取らない。
指標には過去 300 営業日が要るので、**最初に 1 度だけ**まとめて入れる。

### GitHub Actions で回す（推奨）

リポジトリの Settings → Secrets and variables → Actions に 3 つ登録する:

| 名前 | どこで取るか |
|---|---|
| `JQUANTS_API_KEY` | J-Quants ダッシュボード |
| `CLOUDFLARE_API_TOKEN` | dash.cloudflare.com → 右上のアイコン → API Tokens → Create Token → **Edit Cloudflare Workers** テンプレート |
| `CLOUDFLARE_ACCOUNT_ID` | dash.cloudflare.com のドメイン概要ページ右下、または `npx wrangler whoami` |

Actions タブ → 左の一覧から **「バックフィル」** → Run workflow。

| 入力欄 | 入れる値 |
|---|---|
| `from` | 開始日（`2024-01-01` など。B2 で分かった取得可能期間の範囲内で） |
| `to` | 終了日（前営業日でよい） |
| `apply` | **チェックを入れる** ← 既定は off。入れないと SQL を作るだけで D1 に流れない |

`apply` を off のまま回すと、生成された `backfill.sql` が Artifacts に
上がるだけで終わる。**中身を先に見たいとき**はそれでよく、確認したうえで
もう一度 on で回す、という使い方ができる。

### 手元で回す

```bash
export JQUANTS_API_KEY="..."
npm run backfill -- --from 2024-01-01 --to 2026-08-27 --out out/backfill.sql
cd packages/worker
npx wrangler d1 execute invest-db --remote --env production --file=../../out/backfill.sql
```

ここでも **`--env production` が要る**（B1 と同じ理由。付けないと既定の
`[[d1_databases]]` を見に行く）。

**時間がかかる。** 500 銘柄 × 数年で 100 万行規模になる。
Worker で回さないのはこのため（実行時間にも D1 の 1 日あたりの
書き込み上限にも収まらない）。

---

## B4. 日次パイプラインを手で 1 回回す ← **Access より前**

```bash
curl -X POST "https://app.goldencross-incomegains.com/api/run-pipeline"
```

| クエリ | 意味 |
|---|---|
| `?force=1` | 成功済みの日でも走り直す |
| `?date=YYYY-MM-DD` | 日付を指定する |

確認:

```bash
curl -s https://goldencross-incomegains.com/api/health
```

`lastSuccessDate` に日付が入り、`status` が `ok` なら通っている。

ブラウザで `https://app.goldencross-incomegains.com/` を開くと候補が並ぶ。
**この時点ではまだ誰でも見られる**（画面上部に赤い警告が出ている）。次で閉じる。

> **スコアが 0 件のとき**は過去データが足りていない。指標が意味を持つには
> 最低 30 営業日ぶんが要り、それ未満の銘柄は候補に出さない仕様。B3 に戻る。

---

## B5. Cloudflare Access を app ホストにだけ掛ける

### **LP ホストには絶対に掛けない**

掛けると先行登録フォームが誰にも見えなくなり、集客が止まる。
**Subdomain 欄が `app` になっていることを、保存前に必ず確認すること。**

### 画面の場所

```
dash.cloudflare.com
  → 左サイドバー Zero Trust（別画面 one.dash.cloudflare.com に飛ぶ）
  → （初回のみ）チーム名を決める
  → Access → Applications → Add an application → Self-hosted
```

**初回だけチーム名を聞かれる。** ここで決めた名前がそのまま
`<チーム名>.cloudflareaccess.com` になり、あとで `CF_ACCESS_TEAM_DOMAIN` に貼る。
プランは Free（50 ユーザーまで）で足りる。

### アプリケーションの設定

| 欄 | 入れる値 |
|---|---|
| Application name | `invest-dashboard` |
| Session Duration | `24 hours` 程度 |
| **Subdomain** | `app` ← **ここを空にすると LP まで閉じる** |
| **Domain** | `goldencross-incomegains.com` |
| Path | **空のまま**（ホスト全体を対象にする） |

### ポリシー

Next を押すとポリシーの画面になる。

| 欄 | 入れる値 |
|---|---|
| Policy name | `運営者のみ` |
| Action | `Allow` |
| Include | Selector `Emails` → Value に自分のメールアドレス |

ログイン方法は既定の **One-time PIN** でよい（アクセス時にメールへ 6 桁が届く）。
Google などを使いたい場合は Zero Trust → Settings → Authentication で足す。

Save する。

---

## B6. Team domain と AUD を貼って再デプロイ

### 取ってくる値は 2 つ

| 変数 | どこにあるか | 形（照合の基準） |
|---|---|---|
| `CF_ACCESS_AUD` | Access → Applications → `invest-dashboard` を開く → Overview の **Application Audience (AUD) Tag** | **64 桁の 16 進数** |
| `CF_ACCESS_TEAM_DOMAIN` | Zero Trust → Settings → General の **Team domain** | **`.cloudflareaccess.com` で終わる** |

> コンソールの文言や階層は変わることがある。迷ったら**値の形**で見分ける。
> 64 桁の 16 進数が AUD、`.cloudflareaccess.com` で終わるのが Team domain。

### 貼る場所

`packages/worker/wrangler.toml` の **`[env.production.vars]`**（126〜127 行目付近）。
**既定側ではなく本番側**に入れること。

```toml
CF_ACCESS_TEAM_DOMAIN = "yourteam.cloudflareaccess.com"
CF_ACCESS_AUD = "a1b2c3...（64 桁）"
```

```bash
npm run deploy
```

---

## B7. 赤い警告が消えたことを確認する

ブラウザのシークレットウィンドウで `https://app.goldencross-incomegains.com/` を開く。

| 期待 | |
|---|---|
| Access のログイン画面が出る | Access が効いている |
| メールを入れて PIN でログインできる | ポリシーに自分が入っている |
| **画面上部の赤い警告が消えている** | `CF_ACCESS_AUD` が正しく入り、Worker 側でも JWT を検証できている |

警告が残っているなら、`CF_ACCESS_AUD` が別のアプリケーションのものか、
`[env.production.vars]` ではなく既定側に貼っている。

LP 側が閉じていないことも確認する:

```bash
curl -sI https://goldencross-incomegains.com/ | head -1     # 200 のまま
```

### 掛けたあとの運用

| やりたいこと | どうするか |
|---|---|
| 死活監視 | **LP ホストの** `https://goldencross-incomegains.com/api/health` を叩く |
| 日次の実行 | **何もしなくてよい。** Cron は Access を通らない |
| 先行登録を見る | `https://app.goldencross-incomegains.com/waitlist`（Access の内側） |
| CSV で書き出す | 同画面の `/api/waitlist.csv`。Excel で開ける形（UTF-8 BOM 付き） |
| 手でパイプラインを回す | Zero Trust → Access → **Service Auth** でサービストークンを発行し、`CF-Access-Client-Id` / `CF-Access-Client-Secret` ヘッダを付けて叩く。**Cron が動いているなら要らない** |

**書き出した CSV はメールアドレスの塊。** 置き場所と共有範囲に注意すること。

---

# トラック C — 会員公開の判断

`MEMBER_SIGNUP_ENABLED` を `true` にしてよいかは、**技術ではなく契約の問題**。
`docs/DATA-SOURCES.md` の §2 が埋まるまで開けない。

いまの読みは「**会員制（登録ユーザーへの提供）は第三者提供に当たる可能性が高い**」。
J-Quants の標準契約は自己利用が前提に見えるため、Phase 1 は Access で
自分・社内に限定して運用している。これは**推測なので、確認して置き換える。**

## C1. 問い合わせる

まず [jpx-jquants.com](https://jpx-jquants.com/) にログインし、
利用規約の「第三者提供」「再配信」「二次利用」に当たる条項を読む。
そこで判断がつかなければ、問い合わせフォームから聞く。

そのまま貼れる文面:

```
J-Quants API の利用範囲について確認させてください。

【契約情報】
  契約者名: （記入）
  プラン:   （記入）

【やりたいこと】
J-Quants API から取得した日足データをもとに、当方で算出した
テクニカル指標（RSI・MACD・移動平均・ATR など）およびスコア・判定結果を、
ログイン制のウェブ画面で登録ユーザーに表示することを検討しています。

【前提として想定していること】
  ・表示するのは当方で算出した派生値であり、取得した生データそのものを
    一覧表示・ダウンロードさせる機能は設けません
  ・株価の終値など生値を表示する場合も、1 銘柄ずつの参照に限り、
    バルクダウンロード機能は提供しません

【伺いたいこと】
  1. 上記の利用は、利用規約上の第三者提供に該当しますか
  2. 該当する場合、別途のご契約により可能になりますか
  3. 可能な場合、条件と費用の目安をご教示ください

お手数ですが、ご確認のほどよろしくお願いいたします。
```

## C2. 回答を記録する

`docs/DATA-SOURCES.md` の §2 にある記録欄を埋める。

```
確認日:      2026-XX-XX
確認方法:    問い合わせフォーム / 規約 第X条
回答:        （回答をそのまま）
結論:        会員公開 可 / 不可 / 別契約が必要
```

**日付と出典を必ず残すこと。** 規約は改定される。
「いつの時点の、どの条項に基づく判断か」が残っていないと、
半年後に同じ調査をやり直すことになる。

## C3. 可なら開ける

```toml
MEMBER_SIGNUP_ENABLED = "true"
```

`preflight` がここで警告を出す（「§2 が埋まっているか確認しろ」）。
埋めたうえで出る警告なので、無視して進んでよい。

**不可なら開けない。** Access で限定したまま運用を続ける。
先行登録で集めたアドレスは、公開できる形が決まってから使う。

---

## 困ったときの引き先

| 症状 | どこを見るか |
|---|---|
| ドメインが 404 / 522 | `DEPLOY.md`「ドメインに反応しない」 |
| 先行登録が保存されない | `DEPLOY.md`「先行登録が保存されない」 |
| 「データがありません」のまま | `DEPLOY.md`「画面に『データがありません』と出る」 |
| パイプラインは通るがスコアが 0 件 | `DEPLOY.md`「スコアが 0 件」 |
| 項目名で落ちる | `DEPLOY.md`「項目 "close" が見つからない」 |
| `/api/health` が `stale` | `DEPLOY.md`「`/api/health` が `stale` を返す」 |
| ローカルで LP しか開けない | `DEPLOY.md`「ローカルで LP しか開けない」 |

ログを直接見る:

```bash
cd packages/worker
npx wrangler tail --env production
```
