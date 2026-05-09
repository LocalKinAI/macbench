#!/usr/bin/env bash
set -euo pipefail
SANDBOX="$HOME/Desktop/kinbench/026-input"
rm -rf "$SANDBOX"
mkdir -p "$SANDBOX"
# Stash 7 .txt files + 2 non-txt distractors so the answer is "7", not "9".
for i in 1 2 3 4 5 6 7; do
  printf '%d\n' "$i" > "$SANDBOX/file${i}.txt"
done
printf 'distractor\n' > "$SANDBOX/skip.md"
printf 'distractor\n' > "$SANDBOX/skip.log"
rm -f "$HOME/Desktop/kinbench/026-count.txt"
echo "→ planted 7 .txt + 2 non-txt files in $SANDBOX"
