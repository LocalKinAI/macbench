#!/usr/bin/env bash
set -uo pipefail
DST="$HOME/Desktop/kinbench/068-extracted"
for x in alpha beta gamma; do
  if [[ ! -f "$DST/${x}.txt" ]]; then
    echo "FAIL: $DST/${x}.txt missing"; exit 1
  fi
done
echo "PASS: all 3 files extracted"
exit 0
