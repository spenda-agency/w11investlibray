#!/usr/bin/env bash
# デプロイ後の点検。**LP とアプリを別ホストに分けた構成を前提にしている。**
#
#   ./scripts/diagnose.sh                       # ローカル（wrangler dev）
#   LP_URL=https://goldencross-incomegains.com \
#   APP_URL=https://app.goldencross-incomegains.com ./scripts/diagnose.sh
#
# 見ているのは疎通だけではない。**ホストを分けた目的が守れているか**を見る。
#   - 市場データと先行登録の一覧が、公開側から取れないこと
#   - ダッシュボードが、認証なしで開かないこと
#
# ローカルの既定はパス振り分け（site.ts がホスト名未設定のときの挙動）。
set -uo pipefail

LP_URL="${LP_URL:-http://localhost:8787/lp}"
APP_URL="${APP_URL:-http://localhost:8787}"
LP_URL="${LP_URL%/}"
APP_URL="${APP_URL%/}"

# 本番（https の実ドメイン）かローカルかで、期待値が変わる項目がある。
#   - sitemap.xml は絶対 URL を作れないローカルでは 404 を返す（設計どおり）
#   - Access はローカルには掛からないので、アプリ側が 200 でも正しい
if [[ "${LP_URL}" == https://* ]]; then mode=prod; else mode=local; fi

echo "LP  : ${LP_URL}"
echo "アプリ: ${APP_URL}"
echo "モード: ${mode}"
echo

fail=0

status_of() {
  curl -sS -o /dev/null -w '%{http_code}' --max-time 15 "$1" 2>/dev/null || echo '000'
}

# 状態コードを桁の揃う位置に出す（和文ラベルは桁が揃わないので後ろへ回す）
ok()   { printf '  ok   %3s  %s\n' "$1" "$2"; }
ng()   { printf '  NG   %3s  %s\n' "$1" "$2"; fail=1; }
skip() { printf '  --   %3s  %s\n' "$1" "$2"; }

# 期待どおりの状態コードが返ること
expect() {
  local label="$1" url="$2" want="$3" got
  got=$(status_of "${url}")
  if [[ "${got}" == "${want}" ]]; then ok "${got}" "${label}"
  else ng "${got}" "${label}（期待 ${want}）"; fi
}

echo '[1] LP が開いていること'
expect 'トップ'     "${LP_URL}/"           '200'
expect 'robots.txt' "${LP_URL}/robots.txt" '200'

# **/api/health は 200 とは限らない。** 更新が止まっていると 503 を返す
# （監視から失敗として見えるように、意図してそうしてある）。
# ここでは「応答すること」だけ見て、中身の判定は [4] に任せる。
health_status=$(status_of "${LP_URL}/api/health")
case "${health_status}" in
  200|503) ok "${health_status}" '監視用 /api/health（中身は [4]）' ;;
  *)       ng "${health_status}" '監視用 /api/health（期待 200 か 503）' ;;
esac

# sitemap は絶対 URL を組めないと 404 を返す。ローカルではそれが正しい。
sitemap_status=$(status_of "${LP_URL}/sitemap.xml")
if [[ "${mode}" == prod ]]; then
  [[ "${sitemap_status}" == '200' ]] \
    && ok "${sitemap_status}" 'sitemap.xml' \
    || ng "${sitemap_status}" 'sitemap.xml（期待 200）'
else
  skip "${sitemap_status}" 'sitemap.xml — ローカルでは 404 が正しい'
fi

csp=$(curl -sSI --max-time 15 "${LP_URL}/" 2>/dev/null | tr -d '\r' | grep -i '^content-security-policy:' || true)
if [[ -z "${csp}" ]]; then
  echo '  NG   CSP ヘッダが無い'
  fail=1
elif [[ "${csp}" == *"fonts.googleapis.com"* ]]; then
  echo '  ok   CSP に書体の読み込み先が入っている'
else
  echo '  NG   CSP に fonts.googleapis.com が無い → Noto Sans JP が黙って落ちる'
  fail=1
fi
echo

echo '[2] LP から取れてはいけないもの'
# **ここがこの構成の要。** LP 側のルーティングに 1 行足すと漏れる。
expect 'ランキング（404 のはず）'   "${LP_URL}/api/ranking"       '404'
expect 'スクリーナー（404 のはず）' "${LP_URL}/screener"          '404'
expect '銘柄 API（404 のはず）'     "${LP_URL}/api/symbol/X"      '404'
expect '先行登録の一覧（404 のはず）' "${LP_URL}/waitlist"        '404'
expect '先行登録の CSV（404 のはず）' "${LP_URL}/api/waitlist.csv" '404'
echo

echo '[3] ダッシュボードが閉じていること'

# **Access を掛ける前でも、個人情報だけは閉じていること。**
# Worker 側が Access 未設定を検出して 503 を返す（src/auth.ts）。
# ここが 200 なら、ホスト名を知っている誰でもメールアドレスを落とせる。
for p in '/waitlist' '/api/waitlist.csv'; do
  s=$(status_of "${APP_URL}${p}")
  case "${s}" in
    200) ng   "${s}" "**${p} が開いている（メールアドレスが漏れる）**" ;;
    *)   ok   "${s}" "${p} は閉じている" ;;
  esac
done

app_status=$(status_of "${APP_URL}/")
case "${app_status}" in
  30[123578]) ok  "${app_status}" 'Cloudflare Access のログインへ飛んでいる' ;;
  401|403)    ok  "${app_status}" 'Worker 側で認証を要求している' ;;
  200)
    if [[ "${mode}" == prod ]]; then
      ng "${app_status}" '**ダッシュボードが誰でも見られる**'
      echo '            → Access が未設定（docs/GO-LIVE.md の B5）か、'
      echo '              workers_dev を true に戻していないか確認する'
    else
      skip "${app_status}" 'ローカルには Access が掛からない。本番で必ず確認すること'
    fi ;;
  *)          ng  "${app_status}" '想定外。ルートと DNS を確認する' ;;
esac
echo

echo '[4] パイプラインの鮮度'
# LP 側の /api/health を読む。Access の外なので、掛けたあとも読める。
health=$(curl -sS --max-time 15 "${LP_URL}/api/health" 2>/dev/null || echo '{}')
echo "  ${health}"

# **本文は整形された JSON**（json() が JSON.stringify(…, null, 2) を通す）。
# `"status": "ok"` のようにコロンの後に空白が入るので、
# 空白なしのパターンで突き合わせると**どの分岐にも当たらない**。
# 実際そうなっていて、正常でも「更新が止まっている」と誤報していた。
# 表示は整形のまま、判定だけ空白を落として行う。
compact=$(printf '%s' "${health}" | tr -d ' \n\r\t')
case "${compact}" in
  *'"status":"ok"'*)
    echo '  ok   直近の日次処理が成功している' ;;
  *'"lastSuccessDate":null'*)
    echo '  --   日次処理がまだ 1 度も成功していない'
    echo '       → LP だけ公開する段階ならこれで正しい。'
    echo '         ダッシュボードを動かすなら docs/GO-LIVE.md の B3 と B4' ;;
  *)
    echo '  NG   更新が止まっている（stale）'
    echo '       → npx wrangler tail --env production でログを見る'
    fail=1 ;;
esac
echo

if [[ "${fail}" -eq 0 ]]; then
  echo '結果: 問題なし'
else
  echo '結果: 上の NG を確認すること。詳細は docs/DEPLOY.md'
fi
exit "${fail}"
