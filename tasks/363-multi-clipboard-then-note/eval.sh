#!/usr/bin/env bash
# Pass: a note titled 'KinBench Clipboard 363' exists with content
# substantial enough to be from a wikipedia paragraph (>50 chars).
set -uo pipefail
sleep 1
B="$(osascript <<'APPLE' 2>/dev/null
tell application "Notes"
    set ms to (every note whose name = "KinBench Clipboard 363")
    if (count of ms) = 0 then return ""
    return body of (item 1 of ms)
end tell
APPLE
)"
PLAIN="$(printf '%s' "$B" | sed 's/<[^>]*>//g; s/&nbsp;/ /g')"
LEN=$(printf '%s' "$PLAIN" | wc -c | tr -d ' ')
echo "note body length: $LEN chars"
[[ "$LEN" -ge 50 ]] && { echo "PASS: substantial body"; exit 0; } || { echo "FAIL: body too short"; exit 1; }
