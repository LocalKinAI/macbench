#!/usr/bin/env bash
set -uo pipefail
DIR="$HOME/Desktop/kinbench/083-mixed"
rm -rf "$DIR"
mkdir -p "$DIR"
# 3 image-extension, 2 doc-extension, 2 other.
for f in photo1.jpg photo2.png screenshot.heic; do
  printf 'image bytes\n' > "$DIR/$f"
done
for f in report.pdf notes.txt; do
  printf 'doc body\n' > "$DIR/$f"
done
for f in archive.zip script.sh; do
  printf 'other body\n' > "$DIR/$f"
done
echo "→ 3 images + 2 docs + 2 other in $DIR"
