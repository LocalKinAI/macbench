#!/usr/bin/env bash
set -uo pipefail
sleep 1
SENTINEL="$(cat "$HOME/.kinbench/187-sentinel" 2>/dev/null)"
[[ -n "$SENTINEL" ]] || { echo "FAIL: setup didn't stash sentinel"; exit 3; }
B="$(osascript <<'APPLE' 2>/dev/null
tell application "Notes"
    set ms to (every note whose name = "KinBench Clipboard 187")
    if (count of ms) = 0 then return ""
    return body of (item 1 of ms)
end tell
APPLE
)"
PLAIN="$(printf '%s' "$B" | sed 's/<[^>]*>//g; s/&nbsp;/ /g')"
echo "body: $PLAIN"
if printf '%s' "$PLAIN" | grep -q "$SENTINEL"; then
  echo "PASS: note body contains sentinel"; exit 0
fi
echo "FAIL: sentinel not in body"
exit 1
