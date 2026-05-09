#!/usr/bin/env bash
mkdir -p "$HOME/.kinbench"
PRE="$(osascript -e 'tell application "Music" to player state as string' 2>/dev/null || echo "stopped")"
echo "$PRE" > "$HOME/.kinbench/336-pre"
echo "→ pre player state: $PRE"
