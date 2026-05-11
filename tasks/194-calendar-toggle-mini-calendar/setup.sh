#!/usr/bin/env bash
# 194-calendar-toggle-mini-calendar setup
set -uo pipefail
SANDBOX="$HOME/Desktop/kinbench"
mkdir -p "$SANDBOX"
rm -f "$SANDBOX/194-confirm.txt"
/usr/bin/open -a Calendar 2>/dev/null || true
sleep 0.8
echo "→ Calendar opened"
