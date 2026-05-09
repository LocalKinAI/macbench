#!/usr/bin/env bash
set -uo pipefail
F="$HOME/Desktop/kinbench/064-multi-tag.txt"
[[ -f "$F" ]] || { echo "FAIL: $F missing"; exit 1; }
TAGS_XML="$(xattr -p com.apple.metadata:_kMDItemUserTags "$F" 2>/dev/null \
  | xxd -r -p \
  | plutil -convert xml1 -o - - 2>/dev/null || true)"
echo "tags xml: $(printf '%.300s' "$TAGS_XML")"
HAS_Y=$(printf '%s' "$TAGS_XML" | grep -ci "Yellow" || true)
HAS_G=$(printf '%s' "$TAGS_XML" | grep -ci "Green" || true)
echo "Yellow matches: $HAS_Y, Green matches: $HAS_G"
if [[ "$HAS_Y" -ge 1 && "$HAS_G" -ge 1 ]]; then
  echo "PASS: both Yellow + Green tags present"; exit 0
fi
echo "FAIL: need both Yellow and Green tags"; exit 1
