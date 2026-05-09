#!/usr/bin/env bash
set -uo pipefail
sleep 1
B="$(osascript <<'APPLE' 2>/dev/null
tell application "Notes"
    set ms to (every note whose name = "KinBench Bold 173")
    if (count of ms) = 0 then return ""
    return body of (item 1 of ms)
end tell
APPLE
)"
echo "body sample: $(printf '%.300s' "$B")"
if printf '%s' "$B" | grep -qiE '<b[^a-z]|<strong|font-weight\s*:\s*bold|font-weight\s*:\s*700'; then
  echo "PASS: bold markup detected"; exit 0
fi
echo "FAIL: no bold markup in body"
exit 1
