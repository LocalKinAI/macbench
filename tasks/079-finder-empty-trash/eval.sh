#!/usr/bin/env bash
# Pass: no files matching kinbench-079-doomed-* remain in ~/.Trash.
# (We don't require ~/.Trash to be globally empty — user may have
#  unrelated items they don't want us touching.)
set -uo pipefail
LEFT=$(find "$HOME/.Trash" -maxdepth 1 -name 'kinbench-079-doomed-*' 2>/dev/null | wc -l | tr -d ' ')
echo "kinbench-079-doomed-* in Trash: $LEFT"
if [[ "$LEFT" -eq 0 ]]; then
  echo "PASS: trash item gone"; exit 0
fi
echo "FAIL: trash item still present"; exit 1
