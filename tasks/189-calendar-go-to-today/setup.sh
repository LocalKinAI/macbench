#!/usr/bin/env bash
# 189-calendar-go-to-today setup
# Open Calendar and clear any prior confirm file so the agent has
# to actively press Cmd+T (verified via confirm file).
set -uo pipefail
SANDBOX="$HOME/Desktop/kinbench"
mkdir -p "$SANDBOX"
rm -f "$SANDBOX/189-confirm.txt"
/usr/bin/open -a Calendar 2>/dev/null || true
sleep 0.8
echo "→ Calendar opened, confirm file cleared"
