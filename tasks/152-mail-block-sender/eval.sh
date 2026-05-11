#!/usr/bin/env bash
set -uo pipefail
F="$HOME/Desktop/kinbench/152-block-confirm.txt"
if [[ -f "$F" ]] && /usr/bin/grep -q "blocked-sender" "$F"; then
  echo "PASS (soft): confirmation present"
  exit 0
fi
echo "FAIL: no confirmation file"
exit 1
