#!/usr/bin/env bash
# Pass: 3 images live in Images/, 2 docs in Documents/ (or Docs/), rest in Other/.
# Tolerate either Documents/ or Docs/ as the docs-folder name.
set -uo pipefail
DIR="$HOME/Desktop/kinbench/083-mixed"

count_in() {
  local sub="$1"
  if [[ -d "$DIR/$sub" ]]; then
    find "$DIR/$sub" -maxdepth 1 -type f | wc -l | tr -d ' '
  else
    echo 0
  fi
}

IMG=$(count_in Images)
DOC=$(count_in Documents)
[[ "$DOC" -eq 0 ]] && DOC=$(count_in Docs)
OTH=$(count_in Other)

echo "Images=$IMG  Documents=$DOC  Other=$OTH"
if [[ "$IMG" -eq 3 && "$DOC" -eq 2 && "$OTH" -ge 2 ]]; then
  echo "PASS: organized correctly"
  exit 0
fi
echo "FAIL: expected Images=3 Documents=2 Other=2"
exit 1
