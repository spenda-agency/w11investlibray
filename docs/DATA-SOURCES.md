# データソースと利用条件

**このファイルが空のまま会員登録機能を開けてはいけない。**
市場データは「取れるか」より「配ってよいか」が先に来る。

---

## 1. J-Quants API V2（日本株）— Phase 1 で使用

| | |
|---|---|
| エンドポイント | `https://api.jquants.com/v2` |
| 認証 | `x-api-key` ヘッダ |
| キーの入手 | [J-Quants ダッシュボード](https://jpx-jquants.com/) |
| 既存の実績 | `spenda-agency/w09jquantsclaude` で本番運用中。同じキーを流用する |

> V1 は 2026-06-01 に提供終了済み。**V2 のみを使う。**

### 使うエンドポイント

**出典: 本番運用中の `spenda-agency/w09jquantsclaude`（`src/jqsd/jquants.py`）。**
ここは推測で書かない。一度やって高くついた（下記）。

| 用途 | パス | 備考 |
|---|---|---|
| 銘柄一覧 | `/equities/master` | `date` 指定で**その時点の**一覧が取れる。廃止銘柄の把握に必須 |
| 日足 | `/equities/bars/daily` | `date` 指定で **1 リクエストに全銘柄**が返る。500 でも 4,000 でも取得コストは同じ |
| 営業日 | `/markets/calendar` | 営業日判定を推測でやらない |
| 財務 | **未確認** | Phase 1b。V2 での経路を確認してから書く |

**レコードは `data` キーに入る。** ページングは `pagination_key`。
V1 は経路ごとに違うキー（`info` / `daily_quotes` / …）だったが、V2 は揃っている。

> ### 経路を V1 のまま書いて 403 を追いかけた（2026-09-05）
>
> この表は当初 V1 の名前（`/listed/info`・`/prices/daily_quotes`・
> `/markets/trading_calendar`）のまま書かれていた。base URL と認証だけが
> V2 で変わったと思い込み、**確認せずに断定して書いた。**
>
> V1 の経路名を `/v2` に投げると、API Gateway が経路なしとして **403** を返す。
> 5 本すべてが 403 になるので「契約プランの範囲外」に見え、
> **プランを Free → Light に上げ、API キーを 2 度発行し直すまで気付かなかった。**
>
> 答えは最初から応答本文にあった:
>
> ```
> {"message": "The requested endpoint does not exist.
>              Please check the URL, HTTP method, and API version"}
> ```
>
> `check:datasource` が本文を捨てていたので、それが見えなかった。
> **いまは必ず表示する。**

### 項目名のゆらぎ

V2 で項目名が短縮された（`Close` → `C` など）。**長短どちらの名前も正準名へ寄せる層**を
`packages/worker/src/connectors/jquants.ts` に置く（`w09jquantsclaude` の `schema.py` と同じ発想）。

当たらない名前が出たときは `npm run check:datasource` が
**API が実際に返した項目名の一覧**を表示するので、そこを見て別名表に足す。

### プランによる差

契約プランで**取れる期間と遅延が変わる**。実際に契約しているプランで
`npm run check:datasource` を実行し、結果をここに追記すること。

```
確認日:            2026-09-05
プラン:            Light
日足の遅延:        無し（2026-09-02 の 4,440 銘柄が 09-05 に取得できた）
取得可能な期間:    2021-09-05 〜（丸 5 年）
```

**範囲外を要求すると HTTP 400** で、API が範囲そのものを教えてくれる:

```
Your subscription covers the following dates: 2021-09-05 ~ .
If you want more data, please check other plans
```

403（経路違い・権限）と 400（範囲外）は別物。
`check --date 2021-09-02` で確認した（2026-09-05 時点）。

### 実際に返ってくる項目名（2026-09-05 / Light）

**別名表（`FIELD_ALIASES`）の唯一の根拠。** 触るときはここを見る。

| 経路 | 返ってきたキー |
|---|---|
| `/equities/master` | `Date, Code, CoName, CoNameEn, S17, S17Nm, S33, S33Nm, ScaleCat, Mkt, MktNm, Mrgn, MrgnNm, ProdCat` |
| `/equities/bars/daily` | `Date, Code, O, H, L, C, UL, LL, Vo, Va, AdjFactor, AdjO, AdjH, AdjL, AdjC, AdjVo, MktCap, ExRT` |
| `/markets/calendar` | `Date, HolDiv` |

**調整済みの値（`AdjO`〜`AdjVo`）は使わない。** 生値 + `AdjFactor` を
`@invest/core` が調整する設計で、バックテストと本番で同じ計算を通すという
前提がそこに乗っている。`MktCap`・`ExRT`・`UL`/`LL` もいまは取り込まない。

> ### `HolDiv` を別名表に持っておらず、祝日が営業日になっていた
>
> 営業日区分の実際の名前は `HolDiv`。当初の表には
> `HolidayDivision` / `HolidayDiv` / `HdDiv` しか無く、当たらなかった。
>
> 読み出しが `optionalString` だったため `null` が返り、
> **`null !== '0'` が `true`** になって、**祝日を含む全日が営業日**として
> 扱われていた。例外も警告も出ない。
>
> 別名を足したうえで、**`requireString` に変えて取れなければ止める**ようにした。
> 営業日判定は推測で埋めてよい値ではない。

---

## 2. 再配信の可否 — ★ 未解決。会員公開のブロッカー

**現状の判断: 会員制（登録ユーザーへの提供）は「第三者提供」に当たる可能性が高い。**
J-Quants の標準契約は自己利用が前提で、取得データを外部へ提供する場合は
別途の許諾・契約が必要になると読める。

そのため Phase 1 は以下の構成で作る。

1. **Cloudflare Access（Zero Trust）で自分 / 社内のみに限定する。** 自己利用の範囲に収める
2. 会員制のテーブルとルーティングは作るが、`MEMBER_SIGNUP_ENABLED = "false"` で閉じておく
3. 画面に出すのは**派生指標・スコア・判定が中心**。生の日足のバルクダウンロード機能は作らない

### 確認記録（問い合わせたら日付付きで追記する）

```
確認日:      （未記入）
確認方法:    （未記入 — 問い合わせフォーム / 規約の条項番号）
回答:        （未記入）
結論:        （未記入 — 会員公開の可否）
```

**この欄が埋まるまで `MEMBER_SIGNUP_ENABLED` を `true` にしない。**

---

## 3. ニュース — Phase 1b

Phase 1b で足す。**一般ニュース API は著作権と再配信条件が J-Quants とは別問題**になるので、
採用する前にここへ 1 件ずつ条件を書き出す。

Phase 1b の開始時点では次に限定する。

- 発行元が配信を意図している公式 RSS / Atom
- 適時開示（TDnet 等）

保存と表示の方針:

| | |
|---|---|
| R2 に置く原文 | 分析のための**内部保管のみ**。画面には出さない |
| 画面に出すもの | タイトル・出典へのリンク・**自作の要約**のみ |

---

## 4. Phase 3 以降の候補（未確定）

米国株と FX は Phase 3 / 4。既存リポジトリに実績があるので、選定時に参照する。

| ソース | 参考リポジトリ | 用途候補 |
|---|---|---|
| Finnhub | `spenda-agency/finnhub-nasdaq` | 米国株の日足・基礎データ |
| Databento | `spenda-agency/databento` | より詳細な市場データ |

**採用時は必ずこのファイルに「費用 / カバー範囲 / 遅延 / 再配信可否」を追記してから**
`MarketDataSource` の実装に入る。

---

## 免責

このシステムは投資判断の支援を目的とした情報提供であり、投資勧誘ではない。
投資判断は利用者自身の責任で行うこと。
各データソースの利用は、それぞれの提供元の利用規約に従うこと。
