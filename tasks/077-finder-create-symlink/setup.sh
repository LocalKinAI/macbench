#!/usr/bin/env bash
set -euo pipefail
SANDBOX="$HOME/Desktop/kinbench"
mkdir -p "$SANDBOX"
rm -f "$SANDBOX/077-link"
printf 'kinbench-077 target body\n' > "$SANDBOX/077-target.txt"
echo "→ wrote 077-target.txt"
