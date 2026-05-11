#!/usr/bin/env bash
set -uo pipefail
mkdir -p "$HOME/Desktop/kinbench"
rm -f "$HOME/Desktop/kinbench/114-tabgroup-confirm.txt"
osascript -e 'tell application "Safari" to quit' 2>/dev/null || true
sleep 1
osascript -e 'tell application "Safari" to activate' 2>/dev/null
sleep 1
echo "→ Safari open"
