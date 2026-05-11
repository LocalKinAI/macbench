#!/usr/bin/env bash
# 196-calendar-go-to-date setup
set -uo pipefail
SANDBOX="$HOME/Desktop/kinbench"
mkdir -p "$SANDBOX"
rm -f "$SANDBOX/196-confirm.txt"
/usr/bin/open -a Calendar 2>/dev/null || true
sleep 0.8
echo "→ Calendar opened, confirm file cleared"
