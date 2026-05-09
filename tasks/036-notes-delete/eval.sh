#!/usr/bin/env bash
set -uo pipefail
sleep 1
COUNT="$(osascript <<'EOF' 2>/dev/null
tell application "Notes"
    return (count of (every note whose name = "KinBench Test 036 (delete me)"))
end tell
EOF
)"
echo "matching notes still present: $COUNT"
if [[ "$COUNT" == "0" ]]; then
  echo "PASS: note deleted"
  exit 0
fi
echo "FAIL: note still exists ($COUNT match)"
exit 1
