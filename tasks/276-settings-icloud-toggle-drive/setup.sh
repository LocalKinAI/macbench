#!/usr/bin/env bash
set -uo pipefail
mkdir -p "$HOME/.kinbench"
osascript -e 'tell application "System Settings" to quit' 2>/dev/null || true
osascript -e 'tell application "System Preferences" to quit' 2>/dev/null || true
sleep 0.5
echo "→ closed System Settings; agent must navigate to iCloud > iCloud Drive"
