# どこまで動いているかを上から順に確かめる（PowerShell 版）。
#
#   .\scripts\diagnose.ps1
#   $env:BASE_URL = "https://example.com"; .\scripts\diagnose.ps1
#
# このファイルは UTF-8 BOM 付きで保存すること。
# BOM が無いと PowerShell 5.1 が Shift-JIS として読み、日本語が化けて構文が壊れる。
# packages/worker/test/scripts.test.mjs がこれを検査している。

$ErrorActionPreference = "Continue"
$BaseUrl = if ($env:BASE_URL) { $env:BASE_URL } else { "http://localhost:8787" }
Write-Host "診断先: $BaseUrl"
Write-Host ""

$failed = 0

function Test-Endpoint {
    param([string]$Label, [string]$Path, [int]$Expect)
    try {
        $res = Invoke-WebRequest -Uri "$BaseUrl$Path" -Method GET -TimeoutSec 15 -SkipHttpErrorCheck
        $status = [int]$res.StatusCode
    } catch {
        $status = 0
    }
    if ($status -eq $Expect) {
        Write-Host ("  ok   {0,-22} {1} -> {2}" -f $Label, $Path, $status)
    } else {
        Write-Host ("  NG   {0,-22} {1} -> {2} (期待 {3})" -f $Label, $Path, $status, $Expect)
        $script:failed = 1
    }
}

Write-Host "[1] エンドポイントの疎通"
Test-Endpoint "監視用" "/api/health" 200
Test-Endpoint "ダッシュボード" "/" 200
Test-Endpoint "API ランキング" "/api/ranking" 200
Write-Host ""

Write-Host "[2] パイプラインの鮮度"
try {
    $health = Invoke-RestMethod -Uri "$BaseUrl/api/health" -TimeoutSec 15
    Write-Host "  status=$($health.status) lastSuccessDate=$($health.lastSuccessDate) lagDays=$($health.lagDays)"
    if ($health.status -eq "ok") {
        Write-Host "  ok   直近の日次処理が成功している"
    } elseif ($null -eq $health.lastSuccessDate) {
        Write-Host "  NG   日次処理が 1 度も成功していない"
        Write-Host "       -> JQUANTS_API_KEY を登録し、POST /api/run-pipeline を 1 回叩く"
        $failed = 1
    } else {
        Write-Host "  NG   更新が止まっている（stale）"
        $failed = 1
    }
} catch {
    Write-Host "  NG   /api/health に到達できない"
    $failed = 1
}
Write-Host ""

if ($failed -eq 0) {
    Write-Host "結果: 問題なし"
} else {
    Write-Host "結果: 上の NG を確認すること。詳細は docs/DEPLOY.md"
}
exit $failed
