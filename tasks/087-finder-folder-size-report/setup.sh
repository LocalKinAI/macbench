#!/usr/bin/env bash
set -uo pipefail
ROOT="$HOME/Desktop/kinbench/087-tree"
rm -rf "$ROOT"
# 3 top-level folders with predictable byte counts
mkdir -p "$ROOT/folder-small" "$ROOT/folder-medium" "$ROOT/folder-large"
dd if=/dev/zero of="$ROOT/folder-small/a"  bs=100   count=1 2>/dev/null
dd if=/dev/zero of="$ROOT/folder-medium/b" bs=10000 count=1 2>/dev/null
dd if=/dev/zero of="$ROOT/folder-large/c"  bs=1024  count=100 2>/dev/null
rm -f "$HOME/Desktop/kinbench/087-sizes.txt"
echo "→ 3 folders planted (sizes: 100B, 10KB, 100KB)"
