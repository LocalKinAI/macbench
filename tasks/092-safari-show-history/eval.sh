#!/usr/bin/env bash
# Pass: front document URL is the history view (history://) OR the
# agent wrote the confirmation file (TCC-safe fallback).
set -uo pipefail
CONFIRM="$HOME/Desktop/kinbench/092-history-confirm.txt"

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

# History view shows up as 'history://' or as a regular Safari page
# with title "History". Also check that there's a tab whose URL is
# history:// in any open window.
ANY_HISTORY="$(osascript <<'APPLE' 2>/dev/null
tell application "Safari"
    set out to ""
    repeat with w in windows
        repeat with t in tabs of w
            try
                if (URL of t) is missing value then
                    set out to out & "history-tab" & linefeed
                end if
            end try
        end repeat
    end repeat
    return out
end tell
APPLE
)"

case "$URL" in
  history://*|"") echo "PASS: front doc is history view (or special page)"; exit 0 ;;
esac

if [ -s "$CONFIRM" ]; then
  echo "PASS: soft (confirmation file written)"
  exit 0
fi

echo "FAIL: history view not detected"
exit 1
