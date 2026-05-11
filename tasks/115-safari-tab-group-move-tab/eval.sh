#!/usr/bin/env bash
set -uo pipefail
F="$HOME/Desktop/kinbench/115-tabgroup-move-confirm.txt"
if [ -s "$F" ] && grep -qi "kinbench\|moved" "$F"; then
  echo "PASS: confirmation file present"
  exit 0
fi
echo "FAIL: confirmation file missing"
exit 1
