#!/usr/bin/env bash
set -euo pipefail
ROOT="$HOME/Desktop/kinbench/033-folder"
rm -rf "$ROOT" "$HOME/Desktop/kinbench/033-folder.zip"
mkdir -p "$ROOT/sub-a/sub-b"
printf 'top\n' > "$ROOT/top.txt"
printf 'a\n'   > "$ROOT/sub-a/a.txt"
printf 'b\n'   > "$ROOT/sub-a/sub-b/b.txt"
echo "→ planted nested folder structure in $ROOT"
