#!/usr/bin/env bash
set -uo pipefail
F="$HOME/Desktop/kinbench/066-target.txt"
[[ -f "$F" ]] || { echo "FAIL: $F missing"; exit 1; }
TAGS_XML="$(xattr -p com.apple.metadata:_kMDItemUserTags "$F" 2>/dev/null \
  | xxd -r -p \
  | plutil -convert xml1 -o - - 2>/dev/null || true)"
echo "tags xml: $(printf '%.300s' "$TAGS_XML")"
if printf '%s' "$TAGS_XML" | grep -qi "Blue"; then
  echo "PASS: Blue tag applied"; exit 0
fi
echo "FAIL: Blue tag not present"; exit 1
