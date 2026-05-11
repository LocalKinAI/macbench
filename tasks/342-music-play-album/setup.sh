#!/usr/bin/env bash
mkdir -p "$HOME/.kinbench"
# Stop playback first so we can detect a transition to "playing".
osascript -e 'tell application "Music" to pause' 2>/dev/null || true
sleep 0.4
PRE="$(osascript -e 'tell application "Music" to player state as string' 2>/dev/null || echo "stopped")"
echo "$PRE" > "$HOME/.kinbench/342-pre"
echo "-> pre player state: $PRE"
