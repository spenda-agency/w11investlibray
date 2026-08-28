#!/usr/bin/env bash
# どこまで動いているかを上から順に確かめる。
#
#   ./scripts/diagnose.sh
#   BASE_URL=https://example.com ./scripts/diagnose.sh
set -uo pipefail

BASE_URL="${BASE_URL:-http://localhost:8787}"
echo "診断先: ${BASE_URL}"
echo

fail=0

check() {
  local label="$1" path="$2" expect="$3"
  local status
  status=$(curl -sS -o /dev/null -w '%{http_code}' --max-time 15 "${BASE_URL}${path}" 2>/dev/null || echo "000")
  if [[ "${status}" == "${expect}" ]]; then
    printf '  ok   %-22s %s -> %s\n' "${label}" "${path}" "${status}"
  else
    printf '  NG   %-22s %s -> %s (期待 %s)\n' "${label}" "${path}" "${status}" "${expect}"
    fail=1
  fi
}

echo '[1] エンドポイントの疎通'
check '監視用'       '/api/health'  '200'
check 'ダッシュボード' '/'            '200'
check 'API ランキング' '/api/ranking' '200'
echo

echo '[2] パイプラインの鮮度'
health=$(curl -sS --max-time 15 "${BASE_URL}/api/health" 2>/dev/null || echo '{}')
echo "  ${health}"
case "${health}" in
  *'"status":"ok"'*)    echo '  ok   直近の日次処理が成功している' ;;
  *'"lastSuccessDate":null'*)
    echo '  NG   日次処理が 1 度も成功していない'
    echo '       → JQUANTS_API_KEY を登録し、POST /api/run-pipeline を 1 回叩く'
    fail=1 ;;
  *) echo '  NG   更新が止まっている（stale）'; fail=1 ;;
esac
echo

echo '[3] 設定の確認'
for var in JQUANTS_API_KEY; do
  if [[ -n "${!var:-}" ]]; then
    echo "  ok   ${var} がこのシェルに設定されている"
  else
    echo "  --   ${var} は未設定（Worker 側の secret を使うなら不要）"
  fi
done
echo

if [[ "${fail}" -eq 0 ]]; then
  echo '結果: 問題なし'
else
  echo '結果: 上の NG を確認すること。詳細は docs/DEPLOY.md'
fi
exit "${fail}"
