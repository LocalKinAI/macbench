#!/usr/bin/env bash
set -uo pipefail
sleep 1
B="$(osascript <<'APPLE' 2>/dev/null
tell application "Notes"
    set ms to (every note whose name = "KinBench Table 172")
    if (count of ms) = 0 then return ""
    return body of (item 1 of ms)
end tell
APPLE
)"
echo "body sample: $(printf '%.300s' "$B")"
if printf '%s' "$B" | grep -qiE '<table|class="table-cell"|class="td"'; then
  echo "PASS: table markup present"; exit 0
fi
echo "FAIL: no table"
exit 1
