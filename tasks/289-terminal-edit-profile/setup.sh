#!/usr/bin/env bash
set -uo pipefail
mkdir -p "$HOME/Desktop/kinbench"
# Note the current default profile name so we can detect a change
osascript -e 'tell application "Terminal" to return name of default settings' \
  > "$HOME/Desktop/kinbench/289-baseline.txt" 2>/dev/null || echo "Basic" > "$HOME/Desktop/kinbench/289-baseline.txt"
# Ensure a window exists
osascript <<'APPLE' 2>/dev/null || true
tell application "Terminal"
    activate
    if (count of windows) = 0 then do script ""
end tell
APPLE
sleep 0.5
echo "→ baseline profile = $(cat $HOME/Desktop/kinbench/289-baseline.txt)"
