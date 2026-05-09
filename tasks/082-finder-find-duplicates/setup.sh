#!/usr/bin/env bash
# Plant 2 known-duplicate pairs + 1 unique file.
set -uo pipefail
DIR="$HOME/Desktop/kinbench/082-files"
rm -rf "$DIR"
mkdir -p "$DIR"
# Pair A: same content, different names
printf 'duplicate content alpha\n' > "$DIR/a-original.txt"
printf 'duplicate content alpha\n' > "$DIR/a-copy.txt"
# Pair B: same content, different names
printf 'duplicate content beta\nline two\n' > "$DIR/b-first.txt"
printf 'duplicate content beta\nline two\n' > "$DIR/b-second.txt"
# Unique
printf 'unique solo file\n' > "$DIR/c-unique.txt"
rm -f "$HOME/Desktop/kinbench/082-dupes.txt"
echo "→ planted 2 dupe pairs + 1 unique in $DIR"
