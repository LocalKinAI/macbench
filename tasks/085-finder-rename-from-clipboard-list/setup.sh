#!/usr/bin/env bash
set -uo pipefail
DIR="$HOME/Desktop/kinbench/085-rename"
rm -rf "$DIR"
mkdir -p "$DIR"
# Files in alphabetical order; agent reads clipboard, applies new
# names in alphabetical order of the original files.
for f in original-a original-b original-c; do
  printf '%s\n' "$f" > "$DIR/$f.txt"
done
# Pre-load the clipboard with 3 new names.
printf 'apex.txt\nbravo.txt\ncedar.txt' | pbcopy
echo "→ planted 3 files; clipboard contains 3 target names"
