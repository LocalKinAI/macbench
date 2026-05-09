#!/usr/bin/env bash
set -euo pipefail
SANDBOX="$HOME/Desktop/kinbench"
mkdir -p "$SANDBOX/032-aliases"
rm -f "$SANDBOX/032-aliases/"* 2>/dev/null || true
printf 'kinbench-032 alias target\n' > "$SANDBOX/032-target.txt"
echo "→ wrote $SANDBOX/032-target.txt + cleared $SANDBOX/032-aliases/"
