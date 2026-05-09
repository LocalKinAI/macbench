#!/usr/bin/env bash
# Pass: github.com no longer in any tab; apple.com + wikipedia.org still present.
set -uo pipefail

URLS="$(osascript <<'EOF' 2>/dev/null
tell application "Safari"
    if not running then return ""
    set out to ""
    repeat with w in windows
        repeat with t in tabs of w
            set out to out & (URL of t) & linefeed
        end repeat
    end repeat
    return out
end tell
EOF
)"

echo "remaining URLs:"
printf '%s\n' "$URLS"

if printf '%s' "$URLS" | grep -q "github.com"; then
  echo "FAIL: github.com tab still open"
  exit 1
fi
for must_keep in "apple.com" "wikipedia.org"; do
  if ! printf '%s' "$URLS" | grep -q "$must_keep"; then
    echo "FAIL: agent closed $must_keep too (should have kept it)"
    exit 2
  fi
done

echo "PASS: github.com closed, apple.com + wikipedia.org retained"
exit 0
