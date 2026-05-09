#!/usr/bin/env bash
set -euo pipefail
SANDBOX="$HOME/Desktop/kinbench"
SRC="$SANDBOX/008-src"
DST="$SANDBOX/008-dst"
mkdir -p "$SRC" "$DST"
rm -f "$DST/file.txt"
printf 'kinbench-008 movable\n' > "$SRC/file.txt"
echo "→ src: $SRC/file.txt   dst empty: $DST/"
