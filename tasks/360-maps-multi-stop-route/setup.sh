#!/usr/bin/env bash
set -uo pipefail
mkdir -p "$HOME/Desktop/kinbench"
rm -f "$HOME/Desktop/kinbench/360-route.txt"
osascript -e 'tell application "Maps" to quit' 2>/dev/null || true
sleep 1
echo "→ Maps quit, route file cleared"
