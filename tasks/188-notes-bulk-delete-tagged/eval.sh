#!/usr/bin/env bash
set -uo pipefail
sleep 1
N="$(osascript -e 'tell application "Notes" to count of (every note whose name starts with "KinBench Archive Test")' 2>/dev/null)"
echo "remaining matches: $N"
[[ "$N" == "0" ]] && { echo "PASS"; exit 0; } || { echo "FAIL: $N notes still present"; exit 1; }
