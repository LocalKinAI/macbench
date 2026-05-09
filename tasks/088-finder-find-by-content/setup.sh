#!/usr/bin/env bash
set -uo pipefail
DIR="$HOME/Desktop/kinbench/088-corpus"
rm -rf "$DIR"
mkdir -p "$DIR/inner"
# 3 matching files (content contains 'kinbench')
printf 'this contains kinbench in body\n' > "$DIR/match-1.txt"
printf 'multi line\nwith kinbench inside\n' > "$DIR/match-2.txt"
printf 'kinbench at start\n' > "$DIR/inner/match-3.txt"
# Distractors: filename contains it but content doesn't, and vice versa
printf 'kinbench is the filename\n' > "$DIR/non-match-distractor.txt"
printf 'unrelated text\n' > "$DIR/inner/kinbench-named.txt"
rm -f "$HOME/Desktop/kinbench/088-matches.txt"
echo "→ 3 content matches + 2 distractors planted"
