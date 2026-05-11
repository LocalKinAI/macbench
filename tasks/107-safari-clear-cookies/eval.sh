#!/usr/bin/env bash
set -uo pipefail
F="$HOME/Desktop/kinbench/107-cookies-confirm.txt"
if [ -s "$F" ] && grep -qi "example\|cookies\|removed" "$F"; then
  echo "PASS: confirmation file present"
  exit 0
fi
echo "FAIL: confirmation file missing"
exit 1
