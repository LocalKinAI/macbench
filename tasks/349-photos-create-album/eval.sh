#!/usr/bin/env bash
set -uo pipefail
sleep 1
N="$(osascript -e 'tell application "Photos" to count of (every album whose name = "KinBench Album 349")' 2>/dev/null)"
echo "matching albums: $N"
[[ "$N" -ge 1 ]] && { echo "PASS"; exit 0; } || { echo "FAIL"; exit 1; }
