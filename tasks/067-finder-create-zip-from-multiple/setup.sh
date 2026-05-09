#!/usr/bin/env bash
set -euo pipefail
SANDBOX="$HOME/Desktop/kinbench"
DIR="$SANDBOX/067-files"
rm -rf "$DIR" "$SANDBOX/067-archive.zip"
mkdir -p "$DIR"
for i in 1 2 3 4 5; do
  printf 'file %s content\n' "$i" > "$DIR/file${i}.txt"
done
echo "→ planted 5 files in $DIR"
