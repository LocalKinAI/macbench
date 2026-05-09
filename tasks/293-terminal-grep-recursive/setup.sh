#!/usr/bin/env bash
set -uo pipefail
DIR="$HOME/Desktop/kinbench/293-corpus"
rm -rf "$DIR"
mkdir -p "$DIR/inner"
printf 'has kinbench inside\n' > "$DIR/match-1.txt"
printf 'kinbench at root\n' > "$DIR/inner/match-2.txt"
printf 'unrelated content\n' > "$DIR/distractor.txt"
rm -f "$HOME/Desktop/kinbench/293-matches.txt"
