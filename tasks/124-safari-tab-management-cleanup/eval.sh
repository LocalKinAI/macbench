#!/usr/bin/env bash
# Pass: front window has exactly 2 tabs containing apple.com and github.com.
set -uo pipefail
URLS="$(osascript <<'APPLE' 2>/dev/null
tell application "Safari"
    if not running then return ""
    if (count of windows) = 0 then return ""
    set out to ""
    repeat with t in tabs of front window
        set out to out & (URL of t) & linefeed
    end repeat
    return out
end tell
APPLE
)"
echo "remaining tab URLs:"
printf '%s\n' "$URLS"

TAB_COUNT=$(printf '%s\n' "$URLS" | grep -c '^https\?://' || true)
echo "tab count: $TAB_COUNT"
if [ "$TAB_COUNT" -ne 2 ]; then
  echo "FAIL: expected exactly 2 tabs, found $TAB_COUNT"
  exit 1
fi
for dom in apple.com github.com; do
  if ! printf '%s' "$URLS" | grep -q "$dom"; then
    echo "FAIL: $dom missing"
    exit 2
  fi
done
for dom in wikipedia.org mozilla.org example.com; do
  if printf '%s' "$URLS" | grep -q "$dom"; then
    echo "FAIL: $dom should have been closed"
    exit 3
  fi
done
echo "PASS: exactly apple.com + github.com remain"
exit 0
