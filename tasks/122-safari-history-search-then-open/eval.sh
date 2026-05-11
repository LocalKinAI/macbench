#!/usr/bin/env bash
# Pass: Safari's front document URL contains apple.com (agent
# navigated back via history).
set -uo pipefail
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
  *apple.com*) echo "PASS: navigated to apple.com via history"; exit 0 ;;
esac
echo "FAIL: front doc isn't apple.com"
exit 1
