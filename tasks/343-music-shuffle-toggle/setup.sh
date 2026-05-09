#!/usr/bin/env bash
mkdir -p "$HOME/.kinbench"
PRE="$(osascript -e 'tell application "Music" to (shuffle enabled) as string' 2>/dev/null || echo "false")"
echo "$PRE" > "$HOME/.kinbench/343-pre"
echo "→ pre shuffle: $PRE"
