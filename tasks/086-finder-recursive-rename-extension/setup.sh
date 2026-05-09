#!/usr/bin/env bash
set -uo pipefail
DIR="$HOME/Desktop/kinbench/086-photos"
rm -rf "$DIR"
mkdir -p "$DIR/sub-a/sub-b"
for path in "shot-1" "sub-a/shot-2" "sub-a/sub-b/shot-3"; do
  printf 'fake heic body\n' > "$DIR/${path}.heic"
done
# Distractor: existing .jpg shouldn't be touched
printf 'already jpg\n' > "$DIR/existing.jpg"
echo "→ 3 .heic files in nested tree + 1 existing .jpg"
