#!/usr/bin/env bash
set -uo pipefail
SANDBOX="$HOME/Desktop/kinbench"
mkdir -p "$SANDBOX/074-pinned"
rm -f "$SANDBOX/074-pinned-confirm.txt"
echo "→ ready: $SANDBOX/074-pinned"
