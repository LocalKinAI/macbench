#!/usr/bin/env bash
set -uo pipefail
PRE="$(cat "$HOME/.kinbench/274-pre-wp" 2>/dev/null)"
POST="$(osascript -e 'tell application "System Events" to get picture of current desktop' 2>/dev/null || echo "")"
echo "pre:  $PRE"
echo "post: $POST"
if [[ -n "$POST" && "$POST" != "$PRE" ]]; then
  echo "PASS: wallpaper changed"
  exit 0
fi
echo "FAIL: wallpaper unchanged"
exit 1
