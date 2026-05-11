#!/usr/bin/env bash
set -uo pipefail
rm -f "$HOME/Downloads/gpl-3.0.txt"
osascript -e 'tell application "Safari" to quit' 2>/dev/null || true
sleep 1
echo "→ ~/Downloads/gpl-3.0.txt removed if existed"
