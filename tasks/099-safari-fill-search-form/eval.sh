#!/usr/bin/env bash
# Pass: front URL is a google search results page mentioning all
# three query tokens.
set -uo pipefail
URL="$(osascript <<'APPLE' 2>/dev/null
tell application "Safari"
    if not running then return ""
    if (count of windows) = 0 then return ""
    return URL of front document
end tell
APPLE
)"
echo "front URL: $URL"
if [ -z "$URL" ]; then
  echo "FAIL: no Safari front document"
  exit 1
fi
case "$URL" in
  *google.*) : ;;
  *) echo "FAIL: not on google"; exit 2 ;;
esac
DECODED="$(printf '%s' "$URL" | python3 -c 'import sys,urllib.parse;print(urllib.parse.unquote(sys.stdin.read()).lower())' 2>/dev/null || printf '%s' "$URL" | tr '[:upper:]' '[:lower:]')"
for tok in macos computer use; do
  if ! printf '%s' "$DECODED" | grep -q "$tok"; then
    echo "FAIL: '$tok' missing from URL"
    exit 3
  fi
done
echo "PASS: google search with all 3 tokens"
