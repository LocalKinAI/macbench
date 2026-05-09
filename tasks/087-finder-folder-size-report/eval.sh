#!/usr/bin/env bash
set -uo pipefail
F="$HOME/Desktop/kinbench/087-sizes.txt"
[[ -f "$F" ]] || { echo "FAIL: $F not written"; exit 1; }
echo "agent wrote:"
cat "$F"
# All 3 folder names should appear in the report
for folder in folder-small folder-medium folder-large; do
  if ! grep -q "$folder" "$F"; then
    echo "FAIL: $folder not in report"; exit 2
  fi
done
echo "PASS: all 3 folders reported"
exit 0
