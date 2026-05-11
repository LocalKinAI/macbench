#!/usr/bin/env bash
# Tab Groups live in CloudTabs.db (TCC-blocked). Trust the agent's
# confirmation file as the primary signal.
set -uo pipefail
F="$HOME/Desktop/kinbench/114-tabgroup-confirm.txt"
if [ -s "$F" ] && grep -qi "kinbench" "$F"; then
  echo "PASS: confirmation file with KinBench"
  exit 0
fi
echo "FAIL: confirmation file missing or wrong content"
exit 1
