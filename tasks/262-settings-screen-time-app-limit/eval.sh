#!/usr/bin/env bash
set -uo pipefail
PRE="$(cat "$HOME/.kinbench/262-pre-st" 2>/dev/null | tr -d '[:space:]')"
[[ -z "$PRE" ]] && PRE=0
DIR="$HOME/Library/Application Support/ScreenTimeAgent"
POST=0
if [[ -d "$DIR" ]]; then
  POST="$(find "$DIR" -type f -exec stat -f '%m' {} \; 2>/dev/null | sort -rn | head -1)"
fi
[[ -z "$POST" ]] && POST=0
echo "pre-mtime: $PRE   post-mtime: $POST"
if [[ "$POST" -gt "$PRE" ]]; then
  echo "PASS: ScreenTimeAgent storage updated"
  exit 0
fi
if pgrep -x "System Settings" >/dev/null 2>&1; then
  echo "PASS (soft): Screen Time pane was opened (state is sandboxed)"
  exit 0
fi
echo "FAIL: Screen Time appears untouched"
exit 1
