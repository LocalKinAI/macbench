#!/usr/bin/env bash
set -euo pipefail
SANDBOX="$HOME/Desktop/kinbench"
mkdir -p "$SANDBOX"
rm -f "$SANDBOX/075-doc.md"
printf 'kinbench-075 markdown body\n' > "$SANDBOX/075-doc.txt"
echo "→ wrote 075-doc.txt"
