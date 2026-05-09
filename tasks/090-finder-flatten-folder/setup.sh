#!/usr/bin/env bash
set -uo pipefail
TREE="$HOME/Desktop/kinbench/090-tree"
FLAT="$HOME/Desktop/kinbench/090-flat"
rm -rf "$TREE" "$FLAT"
mkdir -p "$TREE/a/aa" "$TREE/b" "$FLAT"
# Files at various depths
printf '1\n' > "$TREE/top.txt"
printf '2\n' > "$TREE/a/inner-a.txt"
printf '3\n' > "$TREE/a/aa/deep.txt"
printf '4\n' > "$TREE/b/inner-b.txt"
echo "→ 4 files at varying depths in $TREE"
