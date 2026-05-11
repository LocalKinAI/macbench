#!/usr/bin/env bash
set -uo pipefail
PRE="$(cat "$HOME/.kinbench/259-pre-display" 2>/dev/null || echo "")"
POST="$(system_profiler SPDisplaysDataType 2>/dev/null | grep -iE 'Resolution|UI Looks like' | head -2)"
echo "pre:"
echo "$PRE"
echo "post:"
echo "$POST"
if [[ -n "$POST" && "$POST" != "$PRE" ]]; then
  echo "PASS: display resolution / scale changed"
  exit 0
fi
if pgrep -x "System Settings" >/dev/null 2>&1 || pgrep -x "System Preferences" >/dev/null 2>&1; then
  echo "PASS (soft): Displays pane open"
  exit 0
fi
echo "FAIL: display unchanged"
exit 1
