#!/usr/bin/env bash
set -uo pipefail
mkdir -p "$HOME/.kinbench"
PRE="$(osascript -e 'tell application "System Events" to get picture of current desktop' 2>/dev/null || echo "")"
echo "$PRE" > "$HOME/.kinbench/274-pre-wp"
echo "→ pre-wallpaper-path: $PRE"
