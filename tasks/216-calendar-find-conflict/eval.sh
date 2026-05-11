#!/usr/bin/env bash
# 216-calendar-find-conflict eval
# Pass: file contains a line referencing both "KinBench Conf A"
# and "KinBench Conf B" and a time in 10:00, 10:30 or 11:00 form.
set -uo pipefail
OUT="$HOME/Desktop/kinbench/216-conflicts.txt"
if [[ ! -f "$OUT" ]]; then
  echo "FAIL: $OUT missing"
  exit 1
fi
echo "file content:"
cat "$OUT"
echo "----"

# Look for a line that mentions both Conf A and Conf B
if grep -qE 'KinBench Conf A.*KinBench Conf B|KinBench Conf B.*KinBench Conf A' "$OUT"; then
  # And mentions a time HH:MM
  if grep -qE '[0-9]{1,2}:[0-9]{2}' "$OUT"; then
    echo "PASS: conflict between Conf A and Conf B reported with time"
    exit 0
  fi
  echo "FAIL: conflict reported but no HH:MM time"
  exit 2
fi
echo "FAIL: no line references both Conf A and Conf B"
exit 3
