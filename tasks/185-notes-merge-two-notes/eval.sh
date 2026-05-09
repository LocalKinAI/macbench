#!/usr/bin/env bash
set -uo pipefail
sleep 1
B="$(osascript <<'APPLE' 2>/dev/null
tell application "Notes"
    set ms to (every note whose name = "KinBench Merged 185")
    if (count of ms) = 0 then return ""
    return body of (item 1 of ms)
end tell
APPLE
)"
PLAIN="$(printf '%s' "$B" | sed 's/<[^>]*>//g; s/&nbsp;/ /g')"
echo "merged body: $(printf '%.300s' "$PLAIN")"
HAS_A=0; HAS_B=0
printf '%s' "$PLAIN" | grep -q "alpha-marker-185" && HAS_A=1
printf '%s' "$PLAIN" | grep -q "bravo-marker-185" && HAS_B=1
echo "has alpha: $HAS_A   has bravo: $HAS_B"
[[ "$HAS_A" -eq 1 && "$HAS_B" -eq 1 ]] && { echo "PASS"; exit 0; } || { echo "FAIL"; exit 1; }
