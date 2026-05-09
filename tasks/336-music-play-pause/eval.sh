#!/usr/bin/env bash
set -uo pipefail
sleep 1
PRE="$(cat "$HOME/.kinbench/336-pre" 2>/dev/null | tr -d '[:space:]')"
POST="$(osascript -e 'tell application "Music" to player state as string' 2>/dev/null || echo "?")"
echo "pre: $PRE  post: $POST"
[[ "$POST" != "$PRE" ]] && { echo "PASS: state toggled"; exit 0; }
echo "FAIL: state unchanged"
exit 1
