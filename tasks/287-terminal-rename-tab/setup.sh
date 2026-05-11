#!/usr/bin/env bash
set -uo pipefail
mkdir -p "$HOME/Desktop/kinbench"
# Ensure a Terminal window exists
osascript <<'APPLE' 2>/dev/null || true
tell application "Terminal"
    activate
    if (count of windows) = 0 then do script ""
    try
        set custom title of selected tab of front window to ""
    end try
end tell
APPLE
sleep 0.5
echo "→ Terminal running, prior custom title cleared"
