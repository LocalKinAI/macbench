#!/usr/bin/env bash
# Plant 5 known-largest files in ~/Documents/kinbench-294/ for predictability.
set -uo pipefail
DIR="$HOME/Documents/kinbench-294"
rm -rf "$DIR"
mkdir -p "$DIR"
# 8 files with predictable size order
for n in 1 2 3 4 5 6 7 8; do
  dd if=/dev/zero of="$DIR/file-${n}.bin" bs=1024 count=$((n * 10)) 2>/dev/null
done
rm -f "$HOME/Desktop/kinbench/294-top5.txt"
echo "→ 8 files in $DIR with sizes 10K..80K"
