#!/usr/bin/env bash
# Ensure TextEdit is running so the agent has something to kill.
set -uo pipefail
mkdir -p "$HOME/Desktop/kinbench"
rm -f "$HOME/Desktop/kinbench/296-kill.txt"
osascript -e 'tell application "TextEdit" to activate' 2>/dev/null || true
sleep 1
PID=$(pgrep -x TextEdit | head -1)
echo "→ TextEdit started (PID $PID)"
