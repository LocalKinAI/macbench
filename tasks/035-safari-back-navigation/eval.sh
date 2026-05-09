#!/usr/bin/env bash
# Pass: front URL is back to apple.com (NOT github.com). This
# only passes if the agent did all three steps in order.
set -uo pipefail

URL="$(osascript <<'EOF' 2>/dev/null
tell application "Safari"
    if not running then return ""
    if (count of windows) = 0 then return ""
    return URL of front document
end tell
EOF
)"

echo "front URL: $URL"
if [[ -z "$URL" ]]; then
  echo "FAIL: no Safari window"
  exit 1
fi
if [[ "$URL" == *"apple.com"* ]] && [[ "$URL" != *"github.com"* ]]; then
  echo "PASS: back-navigated to apple.com"
  exit 0
fi
echo "FAIL: front URL isn't apple.com (or is github.com)"
exit 2
