#!/usr/bin/env bash
set -euo pipefail
DIR="$HOME/Desktop/kinbench/010-batch"
rm -rf "$DIR"
mkdir -p "$DIR"
for x in A B C; do
  printf '%s\n' "$x" > "$DIR/prefix-${x}.txt"
done
echo "→ created prefix-A.txt prefix-B.txt prefix-C.txt in $DIR"
