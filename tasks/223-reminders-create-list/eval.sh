#!/usr/bin/env bash
set -uo pipefail
sleep 1
N="$(osascript -e 'tell application "Reminders" to count of (every list whose name = "kinbench-list-223")' 2>/dev/null)"
echo "lists named kinbench-list-223: $N"
[[ "$N" -ge 1 ]] && { echo "PASS"; exit 0; } || { echo "FAIL"; exit 1; }
