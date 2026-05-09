#!/usr/bin/env bash
set -uo pipefail
F="$HOME/Desktop/kinbench/179-count.txt"
[[ -f "$F" ]] || { echo "FAIL: $F missing"; exit 1; }
N="$(tr -d '[:space:]' < "$F")"
echo "agent reported: $N"
[[ "$N" == "3" ]] && { echo "PASS"; exit 0; } || { echo "FAIL: expected 3"; exit 2; }
