#!/usr/bin/env bash
# 234-reminders-share-list eval
#
# Share sheet visibility isn't queryable. Proxy:
#   - The list still exists (agent didn't accidentally delete it)
#   - Reminders is running
#   - Agent wrote the confirmation file
set -uo pipefail
sleep 1

SANDBOX="$HOME/Desktop/kinbench"
CONFIRM="$SANDBOX/234-share-confirm.txt"

if [[ ! -f "$CONFIRM" ]]; then
  echo "FAIL: confirmation file $CONFIRM missing"
  exit 1
fi
if ! /usr/bin/grep -qi 'PASS' "$CONFIRM"; then
  echo "FAIL: confirmation file doesn't contain PASS"
  exit 2
fi

EXISTS="$(/usr/bin/osascript <<'APPLE' 2>/dev/null
tell application "Reminders"
    try
        get name of (first list whose name = "kinbench-share-234")
        return "true"
    on error
        return "false"
    end try
end tell
APPLE
)"
if [[ "$EXISTS" != "true" ]]; then
  echo "FAIL: list 'kinbench-share-234' missing"
  exit 3
fi

RUNNING="$(/usr/bin/osascript -e 'tell application "System Events" to (name of every process) contains "Reminders"' 2>/dev/null)"
if [[ "$RUNNING" != "true" ]]; then
  echo "FAIL: Reminders is not running"
  exit 4
fi

echo "PASS: list intact + Reminders open + share confirmation written"
exit 0
