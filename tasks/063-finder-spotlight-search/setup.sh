#!/usr/bin/env bash
set -uo pipefail
SANDBOX="$HOME/Desktop/kinbench"
mkdir -p "$SANDBOX/063-deep/nested"
rm -f "$SANDBOX/063-found-path.txt"
# Plant the target one level deep so naive `ls` won't find it
/usr/bin/touch "$SANDBOX/063-deep/nested/kinbench-spotlight-063.txt"
echo "→ planted target at $SANDBOX/063-deep/nested/kinbench-spotlight-063.txt"
