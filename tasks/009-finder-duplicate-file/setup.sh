#!/usr/bin/env bash
set -euo pipefail
SANDBOX="$HOME/Desktop/kinbench"
mkdir -p "$SANDBOX"
# Wipe any prior duplicates so we count fresh.
find "$SANDBOX" -maxdepth 1 -name '009-source*' -delete 2>/dev/null || true
printf 'kinbench-009 dup-me content\n' > "$SANDBOX/009-source.txt"
echo "→ wrote $SANDBOX/009-source.txt"
