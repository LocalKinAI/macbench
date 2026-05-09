#!/usr/bin/env bash
set -euo pipefail
DIR="$HOME/Desktop/kinbench/076-files"
rm -rf "$DIR"
mkdir -p "$DIR"
for x in alpha beta gamma; do
  printf '%s\n' "$x" > "$DIR/draft-${x}.txt"
done
echo "→ wrote draft-alpha/beta/gamma.txt to $DIR"
