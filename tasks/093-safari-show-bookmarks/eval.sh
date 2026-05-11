#!/usr/bin/env bash
# Pass: front document is bookmarks:// or agent wrote confirm file.
set -uo pipefail
CONFIRM="$HOME/Desktop/kinbench/093-bookmarks-confirm.txt"
URL="$(osascript <<'APPLE' 2>/dev/null
tell application "Safari"
    if not running then return ""
    if (count of windows) = 0 then return ""
    try
        return URL of front document
    on error
        return ""
    end try
end tell
APPLE
)"
echo "front URL: $URL"
case "$URL" in
  bookmarks://*|edit-bookmarks://*) echo "PASS: bookmarks view"; exit 0 ;;
esac
if [ -s "$CONFIRM" ]; then
  echo "PASS: soft confirmation"
  exit 0
fi
echo "FAIL: bookmarks view not detected"
exit 1
