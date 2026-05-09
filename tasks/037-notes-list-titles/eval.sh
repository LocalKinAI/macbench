#!/usr/bin/env bash
set -uo pipefail
F="$HOME/Desktop/kinbench/037-titles.txt"
if [[ ! -f "$F" ]]; then
  echo "FAIL: $F missing"
  exit 1
fi

echo "agent wrote:"
cat "$F"

OK=0
for needle in Alpha Beta Gamma; do
  if grep -q "KinBench Listing $needle" "$F"; then
    OK=$((OK+1))
  fi
done

echo "matched: $OK / 3"
if [[ "$OK" -ge 3 ]]; then
  echo "PASS"
  exit 0
fi
echo "FAIL: missing one or more titles (need Alpha + Beta + Gamma)"
exit 2
