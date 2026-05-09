#!/usr/bin/env bash
set -euo pipefail
SANDBOX="$HOME/Desktop/kinbench"
mkdir -p "$SANDBOX"
printf 'kinbench-007 doomed file\n' > "$SANDBOX/007-doomed.txt"
echo "→ wrote $SANDBOX/007-doomed.txt"
