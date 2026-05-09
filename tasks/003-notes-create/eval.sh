#!/usr/bin/env bash
# 003-notes-create eval
#
# Pass criteria: Notes app contains at least one note named
# "KinBench Test 003".

set -uo pipefail

COUNT="$(osascript <<'EOF' 2>/dev/null
tell application "Notes"
    return (count of (every note whose name = "KinBench Test 003"))
end tell
EOF
)"

if [[ -z "$COUNT" ]]; then
  echo "FAIL: AppleScript query failed (Notes not granted automation perm?)"
  exit 1
fi

echo "matching notes: $COUNT"
if [[ "$COUNT" -ge 1 ]]; then
  echo "PASS: KinBench Test 003 note exists"
  exit 0
fi
echo "FAIL: no note titled 'KinBench Test 003' found"
exit 2
