#!/usr/bin/env bash
set -uo pipefail
sleep 1
POST="$(osascript -e 'tell application "Music" to player state as string' 2>/dev/null || echo "?")"
echo "post player state: $POST"
[[ "$POST" == "playing" ]] && { echo "PASS: playing"; exit 0; }
echo "FAIL: not playing"
exit 1
