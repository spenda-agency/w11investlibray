# デプロイ済みの Worker に API を 1 本叩いて、返ってきたものをそのまま見る。
#
#   .\scripts\call-api.ps1
#   .\scripts\call-api.ps1 "/api/ranking?limit=5"
#
# このファイルは UTF-8 BOM 付きで保存すること（理由は diagnose.ps1 と同じ）。

param([string]$Path = "/api/health")

$BaseUrl = if ($env:BASE_URL) { $env:BASE_URL } else { "http://localhost:8787" }
$Url = "$BaseUrl$Path"

$headers = @{ "accept" = "application/json" }
if ($env:CF_ACCESS_CLIENT_ID -and $env:CF_ACCESS_CLIENT_SECRET) {
    $headers["CF-Access-Client-Id"] = $env:CF_ACCESS_CLIENT_ID
    $headers["CF-Access-Client-Secret"] = $env:CF_ACCESS_CLIENT_SECRET
}

Write-Host "GET $Url"
try {
    $res = Invoke-WebRequest -Uri $Url -Headers $headers -Method GET -TimeoutSec 30 -SkipHttpErrorCheck
    Write-Host "HTTP $([int]$res.StatusCode)"
    Write-Host "---"
    try { $res.Content | ConvertFrom-Json | ConvertTo-Json -Depth 8 } catch { Write-Host $res.Content }
    if ([int]$res.StatusCode -ne 200) { exit 1 }
} catch {
    Write-Host "到達できない: $_"
    exit 1
}
