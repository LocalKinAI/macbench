#!/usr/bin/env bash
# 222-reminders-show-today eval
#
# Sidebar selection state is TCC-protected — can't read it via osascript.
# Pass criteria (proxy):
#   - Reminders is running
#   - Agent wrote the confirmation file
set -uo pipefail

SANDBOX="$HOME/Desktop/kinbench"
CONFIRM="$SANDBOX/222-today-confirm.txt"

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

echo "PASS: Reminders open + Today confirmation written"
exit 0
