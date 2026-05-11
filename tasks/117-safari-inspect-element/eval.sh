#!/usr/bin/env bash
# Web Inspector spawns a separate window; we can check Safari has
# multiple windows OR trust the confirm file.
set -uo pipefail
F="$HOME/Desktop/kinbench/117-inspector-confirm.txt"
WIN_COUNT="$(osascript -e 'tell application "Safari" to return (count of windows) as string' 2>/dev/null || echo 0)"
echo "window count: $WIN_COUNT"
if [ "$WIN_COUNT" -ge 2 ] 2>/dev/null; then
  echo "PASS: Safari has >=2 windows (likely inspector)"
  exit 0
fi
if [ -s "$F" ] && grep -qi "inspector" "$F"; then
  echo "PASS: confirmation present"
  exit 0
fi
echo "FAIL: inspector window not detected and no confirm file"
exit 1
