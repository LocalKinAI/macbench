#!/usr/bin/env bash
set -uo pipefail
sleep 1
N="$(osascript -e 'tell application "Reminders" to count of (every list whose name = "kinbench-deleteme-225")' 2>/dev/null)"
echo "remaining: $N"
[[ "$N" == "0" ]] && { echo "PASS"; exit 0; } || { echo "FAIL"; exit 1; }
