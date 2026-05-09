#!/usr/bin/env bash
set -uo pipefail
sleep 1
PRE="$(cat "$HOME/.kinbench/343-pre" 2>/dev/null | tr -d '[:space:]')"
POST="$(osascript -e 'tell application "Music" to (shuffle enabled) as string' 2>/dev/null || echo "?")"
echo "pre: $PRE  post: $POST"
[[ "$POST" != "$PRE" ]] && { echo "PASS"; exit 0; } || { echo "FAIL"; exit 1; }
