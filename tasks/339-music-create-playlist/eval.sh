#!/usr/bin/env bash
set -uo pipefail
sleep 1
N="$(osascript -e 'tell application "Music" to count of (every playlist whose name = "KinBench Mix 339")' 2>/dev/null)"
echo "matching playlists: $N"
[[ "$N" -ge 1 ]] && { echo "PASS"; exit 0; } || { echo "FAIL"; exit 1; }
