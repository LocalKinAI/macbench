#!/usr/bin/env bash
set -uo pipefail
sleep 1
B="$(osascript <<'APPLE' 2>/dev/null
tell application "Notes"
    set ms to (every note whose name = "KinBench Source 177")
    if (count of ms) = 0 then return ""
    return body of (item 1 of ms)
end tell
APPLE
)"
echo "body sample: $(printf '%.300s' "$B")"

# Pass if body contains the target title or an applenotes:// link or wiki-link markup
if printf '%s' "$B" | grep -qE 'KinBench Target 177|applenotes://|class="[^"]*\bnote-link\b|data-onenote-id'; then
  echo "PASS: source note references the target"
  exit 0
fi
echo "FAIL: source body has no reference to 'KinBench Target 177'"
exit 1
