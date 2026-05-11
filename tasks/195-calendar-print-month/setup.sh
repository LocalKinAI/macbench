#!/usr/bin/env bash
# 195-calendar-print-month setup
set -uo pipefail
SANDBOX="$HOME/Desktop/kinbench"
mkdir -p "$SANDBOX"
rm -f "$SANDBOX/195-month.pdf"
/usr/bin/open -a Calendar 2>/dev/null || true
sleep 0.8
echo "→ Calendar opened, target PDF cleared"
