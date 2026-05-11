#!/usr/bin/env bash
set -uo pipefail
mkdir -p "$HOME/Desktop/kinbench"
rm -f "$HOME/Desktop/kinbench/288-confirm.txt"
osascript <<'APPLE' 2>/dev/null || true
tell application "Terminal"
    activate
    if (count of windows) = 0 then do script ""
end tell
APPLE
sleep 0.5
echo "→ Terminal ready"
