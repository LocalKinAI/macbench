#!/usr/bin/env bash
set -uo pipefail
sleep 1

BODY="$(osascript <<'EOF' 2>/dev/null
tell application "Notes"
    set matches to (every note whose name = "KinBench Test 015")
    if (count of matches) = 0 then return ""
    return body of (item 1 of matches)
end tell
EOF
)"

PLAIN="$(printf '%s' "$BODY" | sed 's/<[^>]*>//g; s/\&nbsp;/ /g')"
echo "body (plain): $(printf '%.300s' "$PLAIN")"

if [[ -z "$BODY" ]]; then
  echo "FAIL: note 'KinBench Test 015' not found"
  exit 1
fi
HAS_ORIG=0; HAS_APP=0
printf '%s' "$PLAIN" | grep -q "original line" && HAS_ORIG=1
printf '%s' "$PLAIN" | grep -q "appended line" && HAS_APP=1
echo "original line present: $HAS_ORIG    appended line present: $HAS_APP"

if [[ "$HAS_ORIG" -eq 1 && "$HAS_APP" -eq 1 ]]; then
  echo "PASS: both lines present"
  exit 0
fi
echo "FAIL: missing one of the lines"
exit 2
