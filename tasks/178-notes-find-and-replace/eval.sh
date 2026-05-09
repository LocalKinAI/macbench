#!/usr/bin/env bash
set -uo pipefail
sleep 1
B="$(osascript <<'APPLE' 2>/dev/null
tell application "Notes"
    set ms to (every note whose name = "KinBench Replace 178")
    if (count of ms) = 0 then return ""
    return body of (item 1 of ms)
end tell
APPLE
)"
PLAIN="$(printf '%s' "$B" | sed 's/<[^>]*>//g; s/&nbsp;/ /g')"
echo "body: $(printf '%.200s' "$PLAIN")"
if printf '%s' "$PLAIN" | grep -q "version 2" && ! printf '%s' "$PLAIN" | grep -q "version 1"; then
  echo "PASS: replaced 'version 1' → 'version 2'"; exit 0
fi
echo "FAIL: replacement not done"
exit 1
