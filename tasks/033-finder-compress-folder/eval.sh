#!/usr/bin/env bash
set -uo pipefail
ZIP="$HOME/Desktop/kinbench/033-folder.zip"
if [[ ! -f "$ZIP" ]]; then
  echo "FAIL: $ZIP missing"
  exit 1
fi
LIST="$(unzip -l "$ZIP" 2>&1)"
echo "$LIST" | head -20

# Verify all 3 expected files present.
for needle in "top.txt" "sub-a/a.txt" "sub-a/sub-b/b.txt"; do
  if ! printf '%s' "$LIST" | grep -q "$needle"; then
    echo "FAIL: $needle missing from archive"
    exit 2
  fi
done
echo "PASS: archive contains the full nested structure"
exit 0
