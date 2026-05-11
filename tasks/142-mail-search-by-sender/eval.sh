#!/usr/bin/env bash
set -uo pipefail
F="$HOME/Desktop/kinbench/142-count.txt"
[[ -f "$F" ]] || { echo "FAIL: $F missing"; exit 1; }
C="$(/bin/cat "$F" | /usr/bin/tr -d '[:space:]')"
echo "count file content: '$C'"
if [[ "$C" =~ ^[0-9]+$ ]]; then
  echo "PASS: count written as integer"
  exit 0
fi
echo "FAIL: count not a clean integer"
exit 1
