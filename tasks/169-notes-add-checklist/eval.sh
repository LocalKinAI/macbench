#!/usr/bin/env bash
set -uo pipefail
sleep 1
B="$(osascript <<'APPLE' 2>/dev/null
tell application "Notes"
    set ms to (every note whose name = "KinBench Checklist 169")
    if (count of ms) = 0 then return ""
    return body of (item 1 of ms)
end tell
APPLE
)"
echo "body sample: $(printf '%.300s' "$B")"
# Notes uses checklist via specific HTML — check for ul.gtl-todo or input checkbox
if printf '%s' "$B" | grep -qiE 'gtl-todo|todo-list|input.*checkbox|class="checkbox"'; then
  echo "PASS: note body contains checklist markup"; exit 0
fi
echo "FAIL: no checklist markup found in body"
exit 1
