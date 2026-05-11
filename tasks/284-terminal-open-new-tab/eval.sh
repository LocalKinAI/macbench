#!/usr/bin/env bash
set -uo pipefail
sleep 1
CONFIRM="$HOME/Desktop/kinbench/284-confirm.txt"
BASELINE="$(cat "$HOME/Desktop/kinbench/284-baseline.txt" 2>/dev/null || echo 0)"
CURRENT="$(osascript -e 'tell application "Terminal" to count of tabs of front window' 2>/dev/null || echo 0)"
echo "tabs: baseline=$BASELINE current=$CURRENT"

if [[ -f "$CONFIRM" ]] && grep -qi "tab-opened" "$CONFIRM"; then
  echo "PASS: confirmation file written"
  exit 0
fi
if [[ "$CURRENT" -gt "$BASELINE" ]] 2>/dev/null; then
  echo "PASS: new tab detected ($BASELINE -> $CURRENT)"
  exit 0
fi
echo "FAIL: no confirmation file and no new tab observed"
exit 1
