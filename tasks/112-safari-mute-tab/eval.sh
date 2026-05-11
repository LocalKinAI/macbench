#!/usr/bin/env bash
set -uo pipefail
F="$HOME/Desktop/kinbench/112-mute-confirm.txt"
if [ -s "$F" ] && grep -qi "mute" "$F"; then
  echo "PASS: confirmation file present"
  exit 0
fi
echo "FAIL: mute confirmation missing"
exit 1
