#!/usr/bin/env bash
set -uo pipefail
sleep 1
CONFIRM="$HOME/Desktop/kinbench/283-confirm.txt"
BASELINE="$(cat "$HOME/Desktop/kinbench/283-baseline.txt" 2>/dev/null || echo 0)"
CURRENT="$(osascript -e 'tell application "Terminal" to count of windows' 2>/dev/null || echo 0)"
echo "windows: baseline=$BASELINE current=$CURRENT"

if [[ -f "$CONFIRM" ]] && grep -qi "window-opened" "$CONFIRM"; then
  echo "PASS: confirmation file written"
  exit 0
fi
if [[ "$CURRENT" -gt "$BASELINE" ]] 2>/dev/null; then
  echo "PASS: new Terminal window detected ($BASELINE -> $CURRENT)"
  exit 0
fi
echo "FAIL: no confirmation file and no new window observed"
exit 1
