#!/usr/bin/env bash
# Pass: front window tab 1 is apple.com.
set -uo pipefail
FIRST="$(osascript <<'APPLE' 2>/dev/null
tell application "Safari"
    if not running then return ""
    if (count of windows) = 0 then return ""
    try
        return URL of tab 1 of front window
    on error
        return ""
    end try
end tell
APPLE
)"
echo "first tab URL: $FIRST"
case "$FIRST" in
  *apple.com*) echo "PASS: apple.com is first tab"; exit 0 ;;
esac
echo "FAIL: first tab is not apple.com"
exit 1
