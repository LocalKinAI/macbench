#!/usr/bin/env bash
set -uo pipefail
SANDBOX="$HOME/Desktop/kinbench"
mkdir -p "$SANDBOX"
rm -f "$SANDBOX/056-confirm.txt"
printf 'kinbench-056 fixture for Quick Look\n' > "$SANDBOX/056-target.txt"
echo "→ wrote $SANDBOX/056-target.txt"
