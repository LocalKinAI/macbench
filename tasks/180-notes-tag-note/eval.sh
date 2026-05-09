#!/usr/bin/env bash
set -uo pipefail
sleep 1
B="$(osascript <<'APPLE' 2>/dev/null
tell application "Notes"
    set ms to (every note whose name = "KinBench Tag 180")
    if (count of ms) = 0 then return ""
    return body of (item 1 of ms)
end tell
APPLE
)"
PLAIN="$(printf '%s' "$B" | sed 's/<[^>]*>//g; s/&nbsp;/ /g')"
echo "body: $(printf '%.200s' "$PLAIN")"
if printf '%s' "$PLAIN" | grep -qiE '#kinbench\b|class="hashtag".*kinbench'; then
  echo "PASS: #kinbench tag in body"; exit 0
fi
echo "FAIL: no #kinbench tag"
exit 1
