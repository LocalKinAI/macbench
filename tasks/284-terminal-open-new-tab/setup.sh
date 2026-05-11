#!/usr/bin/env bash
set -uo pipefail
mkdir -p "$HOME/Desktop/kinbench"
rm -f "$HOME/Desktop/kinbench/284-confirm.txt"
# Ensure Terminal is running with at least one window for tab-adding to make sense
osascript <<'APPLE' 2>/dev/null || true
tell application "Terminal"
    activate
    if (count of windows) = 0 then do script ""
end tell
APPLE
sleep 0.5
osascript -e 'tell application "Terminal" to count of tabs of front window' \
  > "$HOME/Desktop/kinbench/284-baseline.txt" 2>/dev/null || echo "0" > "$HOME/Desktop/kinbench/284-baseline.txt"
echo "→ baseline tabs = $(cat $HOME/Desktop/kinbench/284-baseline.txt)"
