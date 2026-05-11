#!/usr/bin/env bash
set -uo pipefail
mkdir -p "$HOME/Desktop/kinbench"
rm -f "$HOME/Desktop/kinbench/365-shot.png"
# Try to start music playing so there is something to pause. Best-effort:
# Music app may not have a library; eval treats "paused" as the pass state
# whether the agent paused or it was never playing.
osascript <<'APPLE' 2>/dev/null || true
tell application "Music"
    try
        activate
        delay 0.3
        try
            play
        end try
    end try
end tell
APPLE
sleep 1
echo "→ Music nudged; screenshot output cleared"
