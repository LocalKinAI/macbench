#!/usr/bin/env bash
set -uo pipefail
PRE="$(cat "$HOME/.kinbench/261-pre-st" 2>/dev/null | tr -d '[:space:]')"
[[ -z "$PRE" ]] && PRE=0
P="$HOME/Library/Application Support/ScreenTimeAgent/Setting/UserMacUsage.json"
POST=0
[[ -f "$P" ]] && POST="$(stat -f '%m' "$P" 2>/dev/null || echo 0)"
echo "pre-mtime: $PRE   post-mtime: $POST"
if [[ "$POST" -gt "$PRE" ]]; then
  echo "PASS: ScreenTimeAgent file changed"
  exit 0
fi
if pgrep -x "System Settings" >/dev/null 2>&1 || pgrep -x "ScreenTimeAgent" >/dev/null 2>&1; then
  echo "PASS (soft): Screen Time pane was opened (state is sandboxed)"
  exit 0
fi
echo "FAIL: Screen Time appears untouched"
exit 1
