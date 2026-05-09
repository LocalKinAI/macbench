#!/usr/bin/env bash
# Pass: at least 2 files matching 009-source* exist, all with identical
# content. macOS Finder Duplicate names them "009-source copy.txt" by
# default; agent could also use cp / typed-rename to anything matching
# the pattern.
set -uo pipefail
SANDBOX="$HOME/Desktop/kinbench"
COUNT=$(find "$SANDBOX" -maxdepth 1 -name '009-source*' -type f | wc -l | tr -d ' ')
echo "matches: $COUNT"
if [[ "$COUNT" -lt 2 ]]; then
  echo "FAIL: expected ≥2 files matching 009-source*, found $COUNT"
  exit 1
fi

EXPECTED='kinbench-009 dup-me content'
while IFS= read -r f; do
  ACTUAL="$(cat "$f")"
  if [[ "$ACTUAL" != "$EXPECTED" ]]; then
    echo "FAIL: $f content differs from original"
    exit 2
  fi
done < <(find "$SANDBOX" -maxdepth 1 -name '009-source*' -type f)

echo "PASS: $COUNT files, all matching original content"
exit 0
