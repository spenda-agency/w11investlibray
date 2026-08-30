# 開発規約

このリポジトリで作業するときの前提。**サブブランチで機能を足す前に必ず読むこと。**

## この構成が守っているもの

1. **指標計算の実装は 1 本だけ。** `packages/core` が唯一の計算場所。
   Worker（日次）と batch（バックテスト）が同じコードを呼ぶ。
   ここを分けるとバックテストが本番の挙動を保証しなくなる。
2. **`packages/core` に依存パッケージを足さない。** `dependencies` は空のまま。
   `fetch` / `D1` / `fs` / `process` / `Date.now()` / `Math.random()` を参照しない。
   入力は配列、出力は配列。同じ入力からは常に同じ出力。
3. **Point-in-Time を壊さない。** 財務は `disclosed_at`、ニュースは `published_at` で絞る。
   上場廃止銘柄を `symbols` から消さない。バックテストで同日終値約定をしない。
4. **スコア定義は `docs/SCORING.md` が正。** 配点を変えるときは
   先にドキュメントを更新し、`score_version` を上げてから実装を直す。

## 作業の順序

```
docs/SCORING.md を更新
      ↓
packages/core にテストを書く（先に）
      ↓
packages/core を実装
      ↓
migrations/ に追加（既存ファイルは編集しない。連番で足す）
      ↓
packages/worker で使う
```

## コマンド

| | |
|---|---|
| `npm run typecheck` | 全 workspace の型チェック |
| `npm test` | 全 workspace のテスト（ネットワーク不要） |
| `npm run dev` | Worker をローカル起動 |
| `npm run check:datasource` | J-Quants の疎通・プラン・項目名の確認（APIキーが要る） |

## マイグレーション

`migrations/` は**連番で足すだけ**。適用済みのファイルを編集しない。
D1 は本番でロールバックが効かないので、破壊的変更は
「新しい列を足す → 両方書く → 読み替える → 古い列を消す」の 4 段階で行う。

## Windows で作業する場合

- **`wrangler` は必ずリポジトリ内で実行する。** ホームディレクトリで走らせると
  `Application Data` の権限エラーになる
- **`.ps1` は UTF-8 BOM 付きで保存する。** PowerShell 5.1 は BOM が無いと Shift-JIS として
  読み、日本語が化けて構文が壊れる。`npm test` がこれを検査している

## 画面まわり

配色と書体は `packages/worker/src/ui/tokens.ts` が唯一の定義。
**他の場所でパレットを再定義しない**（`npm test` が落ちる）。
LP のデザイン仕様は `docs/LP-BRIEF.md`。

## やらないこと

- Claude に将来の株価を予測させない。役割は分類・要約・説明に限る
- バックテストで検証していないルールを画面上で「推奨」と表示しない
- 生データのバルクダウンロード機能を作らない（`docs/DATA-SOURCES.md` の再配信条件）
