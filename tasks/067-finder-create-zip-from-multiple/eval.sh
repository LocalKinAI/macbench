#!/usr/bin/env bash
set -uo pipefail
ZIP="$HOME/Desktop/kinbench/067-archive.zip"
[[ -f "$ZIP" ]] || { echo "FAIL: $ZIP missing"; exit 1; }
LIST="$(unzip -l "$ZIP" 2>&1)"
echo "$LIST" | head -10
for i in 1 2 3 4 5; do
  if ! printf '%s' "$LIST" | grep -q "file${i}.txt"; then
    echo "FAIL: file${i}.txt missing from archive"; exit 2
  fi
done
echo "PASS: archive contains all 5 files"
exit 0
