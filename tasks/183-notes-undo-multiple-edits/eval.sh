#!/usr/bin/env bash
set -uo pipefail
sleep 1
B="$(osascript <<'APPLE' 2>/dev/null
tell application "Notes"
    set ms to (every note whose name = "KinBench Undo 183")
    if (count of ms) = 0 then return ""
    return body of (item 1 of ms)
end tell
APPLE
)"
PLAIN="$(printf '%s' "$B" | sed 's/<[^>]*>//g; s/&nbsp;/ /g')"
echo "body plain: $(printf '%.300s' "$PLAIN")"

if printf '%s' "$PLAIN" | grep -q "kinbench-original-line"; then
  if printf '%s' "$PLAIN" | grep -q "KINBENCH-EXTRA-TEXT-183"; then
    echo "FAIL: extra text still present, undo did not run"
    exit 1
  fi
  echo "PASS: original line preserved, extra text removed (undo worked)"
  exit 0
fi
echo "FAIL: original line missing"
exit 1
