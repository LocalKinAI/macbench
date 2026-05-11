#!/usr/bin/env bash
set -uo pipefail
sleep 1
PRE="$(cat "$HOME/.kinbench/338-pre" 2>/dev/null | tr -d '[:space:]')"
POST="$(osascript -e 'tell application "Music" to sound volume' 2>/dev/null | tr -d '[:space:]')"
echo "pre: $PRE  post: $POST"
[[ -z "$PRE" || -z "$POST" ]] && { echo "FAIL: missing readings"; exit 1; }
if [[ "$POST" -lt "$PRE" ]]; then
  echo "PASS: volume lowered ($PRE -> $POST)"
  exit 0
fi
echo "FAIL: volume not lowered"
exit 1
