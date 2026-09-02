# デプロイ後の点検（PowerShell 版）。**LP とアプリを別ホストに分けた構成を前提にしている。**
#
#   .\scripts\diagnose.ps1
#   $env:LP_URL = "https://goldencross-incomegains.com"
#   $env:APP_URL = "https://app.goldencross-incomegains.com"
#   .\scripts\diagnose.ps1
#
# 見ているのは疎通だけではない。**ホストを分けた目的が守れているか**を見る。
#   - 市場データと先行登録の一覧が、公開側から取れないこと
#   - ダッシュボードが、認証なしで開かないこと
#
# このファイルは UTF-8 BOM 付きで保存すること。
# BOM が無いと PowerShell 5.1 が Shift-JIS として読み、日本語が化けて構文が壊れる。
# packages/worker/test/scripts.test.mjs がこれを検査している。

$ErrorActionPreference = "Continue"
$LpUrl  = if ($env:LP_URL)  { $env:LP_URL.TrimEnd('/') }  else { "http://localhost:8787/lp" }
$AppUrl = if ($env:APP_URL) { $env:APP_URL.TrimEnd('/') } else { "http://localhost:8787" }

Write-Host "LP  : $LpUrl"
Write-Host "アプリ: $AppUrl"
Write-Host ""

$failed = 0

function Get-Status {
    param([string]$Url)
    try {
        $res = Invoke-WebRequest -Uri $Url -Method GET -TimeoutSec 15 -SkipHttpErrorCheck `
            -MaximumRedirection 0 -ErrorAction SilentlyContinue
        return [int]$res.StatusCode
    } catch {
        if ($_.Exception.Response) { return [int]$_.Exception.Response.StatusCode }
        return 0
    }
}

function Test-Status {
    param([string]$Label, [string]$Url, [int]$Expect)
    $got = Get-Status $Url
    if ($got -eq $Expect) {
        Write-Host ("  ok   {0,-30} {1}" -f $Label, $got)
    } else {
        Write-Host ("  NG   {0,-30} {1}（期待 {2}）" -f $Label, $got, $Expect)
        $script:failed = 1
    }
}

Write-Host "[1] LP が開いていること"
Test-Status "トップ"             "$LpUrl/"            200
Test-Status "監視用 /api/health"  "$LpUrl/api/health"  200
Test-Status "robots.txt"         "$LpUrl/robots.txt"  200
Test-Status "sitemap.xml"        "$LpUrl/sitemap.xml" 200

try {
    $head = Invoke-WebRequest -Uri "$LpUrl/" -Method GET -TimeoutSec 15 -SkipHttpErrorCheck
    $csp = $head.Headers["Content-Security-Policy"]
    if (-not $csp) {
        Write-Host "  NG   CSP ヘッダが無い"
        $failed = 1
    } elseif ($csp -like "*fonts.googleapis.com*") {
        Write-Host "  ok   CSP に書体の読み込み先が入っている"
    } else {
        Write-Host "  NG   CSP に fonts.googleapis.com が無い → Noto Sans JP が黙って落ちる"
        $failed = 1
    }
} catch {
    Write-Host "  NG   CSP を確認できなかった: $_"
    $failed = 1
}
Write-Host ""

Write-Host "[2] LP から取れてはいけないもの"
# **ここがこの構成の要。** LP 側のルーティングに 1 行足すと漏れる。
Test-Status "ランキング（404 のはず）"     "$LpUrl/api/ranking"       404
Test-Status "スクリーナー（404 のはず）"   "$LpUrl/screener"          404
Test-Status "銘柄 API（404 のはず）"       "$LpUrl/api/symbol/X"      404
Test-Status "先行登録の一覧（404 のはず）" "$LpUrl/waitlist"          404
Test-Status "先行登録の CSV（404 のはず）" "$LpUrl/api/waitlist.csv"  404
Write-Host ""

Write-Host "[3] ダッシュボードが閉じていること"
$appStatus = Get-Status "$AppUrl/"
if ($appStatus -ge 301 -and $appStatus -le 308) {
    Write-Host "  ok   $appStatus — Cloudflare Access のログインへ飛んでいる"
} elseif ($appStatus -eq 401 -or $appStatus -eq 403) {
    Write-Host "  ok   $appStatus — Worker 側で認証を要求している"
} elseif ($appStatus -eq 200) {
    Write-Host "  NG   200 — **ダッシュボードが誰でも見られる**"
    Write-Host "       → Access が未設定（docs/GO-LIVE.md の B5）か、"
    Write-Host "         workers_dev を true に戻していないか確認する"
    $failed = 1
} else {
    Write-Host "  NG   $appStatus — 想定外。ルートと DNS を確認する"
    $failed = 1
}
Write-Host ""

Write-Host "[4] パイプラインの鮮度"
# LP 側の /api/health を読む。Access の外なので、掛けたあとも読める。
try {
    $health = (Invoke-WebRequest -Uri "$LpUrl/api/health" -Method GET -TimeoutSec 15 -SkipHttpErrorCheck).Content
} catch {
    $health = "{}"
}
Write-Host "  $health"
if ($health -like '*"status":"ok"*') {
    Write-Host "  ok   直近の日次処理が成功している"
} elseif ($health -like '*"lastSuccessDate":null*') {
    Write-Host "  --   日次処理がまだ 1 度も成功していない"
    Write-Host "       → LP だけ公開する段階ならこれで正しい。"
    Write-Host "         ダッシュボードを動かすなら docs/GO-LIVE.md の B3 と B4"
} else {
    Write-Host "  NG   更新が止まっている（stale）"
    Write-Host "       → npx wrangler tail --env production でログを見る"
    $failed = 1
}
Write-Host ""

if ($failed -eq 0) {
    Write-Host "結果: 問題なし"
} else {
    Write-Host "結果: 上の NG を確認すること。詳細は docs/DEPLOY.md"
}
exit $failed
