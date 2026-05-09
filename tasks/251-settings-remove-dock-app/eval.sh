#!/usr/bin/env bash
set -uo pipefail
PRE=$(cat "$HOME/.kinbench/251-pre" 2>/dev/null | tr -d '[:space:]')
POST=$(defaults read com.apple.dock persistent-apps 2>/dev/null | grep -c TextEdit || echo 0)
echo "pre: $PRE  post: $POST"
[[ "$POST" -lt "$PRE" ]] && { echo "PASS: TextEdit removed"; exit 0; } || { echo "FAIL"; exit 1; }
