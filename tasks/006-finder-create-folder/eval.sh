#!/usr/bin/env bash
set -uo pipefail
TARGET="$HOME/Desktop/kinbench/006-myfolder"
if [[ -d "$TARGET" ]]; then
  echo "PASS: $TARGET exists as a directory"
  exit 0
fi
echo "FAIL: $TARGET missing or not a directory"
exit 1
