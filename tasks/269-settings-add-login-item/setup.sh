#!/usr/bin/env bash
osascript -e 'tell application "System Events" to delete every login item whose name is "TextEdit"' 2>/dev/null || true
PRE="$(osascript -e 'tell application "System Events" to count of (every login item whose name is "TextEdit")' 2>/dev/null || echo "0")"
mkdir -p "$HOME/.kinbench"
echo "$PRE" > "$HOME/.kinbench/269-pre"
echo "→ TextEdit removed from login items (pre: $PRE)"
