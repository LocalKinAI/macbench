#!/usr/bin/env bash
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
[[ -z "$URL" ]] && { echo "FAIL: no Safari window"; exit 1; }
case "$URL" in
  *wikipedia.org*) echo "PASS"; exit 0 ;;
  *) echo "FAIL: front URL not wikipedia.org"; exit 2 ;;
esac
