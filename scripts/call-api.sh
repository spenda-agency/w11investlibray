#!/usr/bin/env bash
# デプロイ済みの Worker に API を 1 本叩いて、返ってきたものをそのまま見る。
#
#   ./scripts/call-api.sh                       # /api/health
#   ./scripts/call-api.sh /api/ranking?limit=5
#   BASE_URL=https://example.com ./scripts/call-api.sh /api/ranking
#
# Cloudflare Access の背後にある場合、/api/health 以外は
# サービストークンが要る。CF_ACCESS_CLIENT_ID / CF_ACCESS_CLIENT_SECRET を設定する。
set -euo pipefail

BASE_URL="${BASE_URL:-http://localhost:8787}"
PATH_PART="${1:-/api/health}"
URL="${BASE_URL}${PATH_PART}"

headers=(-H 'accept: application/json')
if [[ -n "${CF_ACCESS_CLIENT_ID:-}" && -n "${CF_ACCESS_CLIENT_SECRET:-}" ]]; then
  headers+=(-H "CF-Access-Client-Id: ${CF_ACCESS_CLIENT_ID}")
  headers+=(-H "CF-Access-Client-Secret: ${CF_ACCESS_CLIENT_SECRET}")
fi

echo "GET ${URL}"
status=$(curl -sS -o /tmp/call-api-body -w '%{http_code}' "${headers[@]}" "${URL}")
echo "HTTP ${status}"
echo '---'
if command -v jq >/dev/null 2>&1; then
  jq . /tmp/call-api-body 2>/dev/null || cat /tmp/call-api-body
else
  cat /tmp/call-api-body
fi
echo
[[ "${status}" == "200" ]] || exit 1
