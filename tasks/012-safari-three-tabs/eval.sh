#!/usr/bin/env bash
# Pass: front Safari window has at least 3 tabs, and the three target
# domains are all present somewhere in the open tab URLs.
set -uo pipefail

URLS="$(osascript <<'EOF' 2>/dev/null
tell application "Safari"
    if not running then return ""
    if (count of windows) = 0 then return ""
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

echo "open tab URLs:"
printf '%s\n' "$URLS" | head -20

if [[ -z "$URLS" ]]; then
  echo "FAIL: Safari not running or no tabs"
  exit 1
fi

TAB_COUNT=$(printf '%s\n' "$URLS" | grep -c '^https\?://' || true)
if [[ "$TAB_COUNT" -lt 3 ]]; then
  echo "FAIL: only $TAB_COUNT tabs open, need ≥3"
  exit 2
fi

for domain in "apple.com" "github.com" "wikipedia.org"; do
  if ! printf '%s' "$URLS" | grep -q "$domain"; then
    echo "FAIL: $domain not found in any open tab"
    exit 3
  fi
done

echo "PASS: $TAB_COUNT tabs, all three target domains present"
exit 0
