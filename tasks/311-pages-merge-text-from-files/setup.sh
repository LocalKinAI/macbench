#!/usr/bin/env bash
set -euo pipefail
mkdir -p "$HOME/Desktop/kinbench/311-sources"
rm -rf "$HOME/Desktop/kinbench/311-merged.pages"
rm -f "$HOME/Desktop/kinbench/311-merge-confirm.txt"

printf 'Alpha block: KinBench 311 part one.\n' > "$HOME/Desktop/kinbench/311-sources/a.txt"
printf 'Bravo block: KinBench 311 part two.\n' > "$HOME/Desktop/kinbench/311-sources/b.txt"
printf 'Charlie block: KinBench 311 part three.\n' > "$HOME/Desktop/kinbench/311-sources/c.txt"

osascript -e 'tell application "Pages" to quit' >/dev/null 2>&1 || true
sleep 0.4
echo "→ wrote 311-sources/{a,b,c}.txt, cleared 311-merged.pages"
