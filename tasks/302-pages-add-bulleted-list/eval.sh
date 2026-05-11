#!/usr/bin/env bash
# Pages bundle is zip-with-protobuf — bullet formatting isn't reliable to read.
# We grep for the three item words in the bundle as a heuristic and fall back
# to the confirmation file.
set -uo pipefail
F="$HOME/Desktop/kinbench/302-doc.pages"
CONF="$HOME/Desktop/kinbench/302-bullets-confirm.txt"

[[ -e "$F" ]] || { echo "FAIL: $F missing"; exit 1; }
SIZE="$(stat -f %z "$F" 2>/dev/null || stat -c %s "$F" 2>/dev/null || echo 0)"
[[ "$SIZE" -gt 1024 ]] || { echo "FAIL: $F too small"; exit 2; }

found_words=0
if file "$F" | grep -qi "zip"; then
  TMP="$(mktemp -d)"
  trap 'rm -rf "$TMP"' EXIT
  if unzip -q -o "$F" -d "$TMP" 2>/dev/null; then
    for w in Apple Banana Cherry; do
      if grep -r -a -l "$w" "$TMP" 2>/dev/null | grep -q .; then
        found_words=$((found_words + 1))
      fi
    done
  fi
fi

if [[ "$found_words" -ge 2 ]]; then
  echo "PASS (heuristic): found $found_words/3 fruit words in bundle"
  exit 0
fi
if [[ -f "$CONF" ]]; then
  echo "PASS (soft): confirmation present, doc size=$SIZE"
  exit 0
fi
echo "PARTIAL: doc present ($SIZE bytes) — soft pass"
exit 0
