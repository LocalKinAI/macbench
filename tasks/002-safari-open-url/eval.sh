#!/usr/bin/env bash
# 002-safari-open-url eval
#
# Pass criteria:
#   - Safari has at least one window
#   - The frontmost tab's URL contains "apple.com/macos"
#
# Uses AppleScript (Safari exposes a robust dictionary). AX-based
# query would also work but AppleScript is shorter for this case.

set -uo pipefail

URL="$(osascript <<'EOF' 2>/dev/null
tell application "Safari"
    if not running then return ""
    if (count of windows) = 0 then return ""
    return URL of front document
end tell
EOF
)"

if [[ -z "$URL" ]]; then
  echo "FAIL: Safari not running or no front document"
  exit 1
fi

echo "frontmost URL: $URL"

if [[ "$URL" == *"apple.com/macos"* ]]; then
  echo "PASS: navigated to apple.com/macos"
  exit 0
fi

# Fallback: agent may have hit apple.com/ which then redirected.
# We accept apple.com only if the path includes /macos somewhere.
echo "FAIL: URL doesn't contain 'apple.com/macos'"
exit 2
