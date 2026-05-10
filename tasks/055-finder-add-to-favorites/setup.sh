#!/usr/bin/env bash
set -uo pipefail
SANDBOX="$HOME/Desktop/kinbench"
mkdir -p "$SANDBOX"
rm -f "$SANDBOX/055-favorites-confirm.txt"
echo "→ kinbench dir ready at $SANDBOX"
