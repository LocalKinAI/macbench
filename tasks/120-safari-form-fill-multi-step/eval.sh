#!/usr/bin/env bash
# Pass: landing URL recorded AND it's not the DuckDuckGo SERP itself
# (so the agent did actually click into a result).
set -uo pipefail
F="$HOME/Desktop/kinbench/120-landing.txt"
[[ -f "$F" ]] || { echo "FAIL: $F missing"; exit 1; }
URL="$(head -n 1 "$F" | tr -d '[:space:]')"
echo "landing URL: '$URL'"
if [[ -z "$URL" ]]; then
  echo "FAIL: empty URL"
  exit 2
fi
case "$URL" in
  http://*|https://*) ;;
  *) echo "FAIL: '$URL' is not http(s)"; exit 3 ;;
esac
# Reject the SERP itself
if echo "$URL" | grep -qiE 'duckduckgo\.com/?(\?|$)'; then
  echo "FAIL: landed on DDG SERP, not a result page"
  exit 4
fi
echo "PASS: landed on a non-DDG result page"
exit 0
