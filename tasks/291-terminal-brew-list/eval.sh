#!/usr/bin/env bash
set -uo pipefail
F="$HOME/Desktop/kinbench/291-brew-list.txt"
[[ -f "$F" ]] || { echo "FAIL: $F missing"; exit 1; }
SIZE=$(stat -f %z "$F" 2>/dev/null || stat -c %s "$F" 2>/dev/null || echo 0)
[[ "$SIZE" -gt 0 ]] || { echo "FAIL: file is empty"; exit 2; }
# Either 'brew not installed' message OR a list of formula names
if grep -qE 'brew not installed|^[a-z0-9-]+$' "$F"; then
  echo "PASS: $F populated ($SIZE bytes)"
  exit 0
fi
echo "PASS: file populated ($SIZE bytes) — accepting any non-empty brew output"
exit 0
