#!/usr/bin/env bash
# Pass: directory exists AND has a .git subdirectory with a HEAD ref.
set -uo pipefail
DIR="$HOME/Desktop/kinbench/043-repo"
if [[ ! -d "$DIR" ]]; then
  echo "FAIL: $DIR doesn't exist"
  exit 1
fi
if [[ ! -d "$DIR/.git" ]]; then
  echo "FAIL: $DIR exists but no .git/"
  exit 2
fi
if [[ ! -f "$DIR/.git/HEAD" ]]; then
  echo "FAIL: .git/ exists but no HEAD ref (not really initialized)"
  exit 3
fi
echo "PASS: git repo initialized at $DIR"
exit 0
