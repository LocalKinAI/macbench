#!/usr/bin/env bash
set -uo pipefail
mkdir -p "$HOME/Desktop/kinbench"
rm -f "$HOME/Desktop/kinbench/120-landing.txt"
osascript -e 'tell application "Safari" to quit' 2>/dev/null || true
sleep 1
echo "→ Safari quit, landing file cleared"
