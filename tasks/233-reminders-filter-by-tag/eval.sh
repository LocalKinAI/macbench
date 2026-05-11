#!/usr/bin/env bash
# 233-reminders-filter-by-tag eval
#
# Sidebar/tag-filter state isn't queryable. Proxy:
#   - Reminders is running
#   - Agent wrote the confirmation file
set -uo pipefail

SANDBOX="$HOME/Desktop/kinbench"
CONFIRM="$SANDBOX/233-tag-confirm.txt"

if [[ ! -f "$CONFIRM" ]]; then
  echo "FAIL: confirmation file $CONFIRM missing"
  exit 1
fi
if ! /usr/bin/grep -qi 'PASS' "$CONFIRM"; then
  echo "FAIL: confirmation file doesn't contain PASS"
  exit 2
fi

RUNNING="$(/usr/bin/osascript -e 'tell application "System Events" to (name of every process) contains "Reminders"' 2>/dev/null)"
if [[ "$RUNNING" != "true" ]]; then
  echo "FAIL: Reminders is not running"
  exit 3
fi

echo "PASS: Reminders open + tag-filter confirmation written"
exit 0
