#!/usr/bin/env bash
set -uo pipefail
F="$HOME/Desktop/kinbench/065-tagged.txt"
[[ -f "$F" ]] || { echo "FAIL: $F missing"; exit 1; }
TAGS_XML="$(xattr -p com.apple.metadata:_kMDItemUserTags "$F" 2>/dev/null \
  | xxd -r -p \
  | plutil -convert xml1 -o - - 2>/dev/null || true)"
echo "tags xml: $(printf '%.300s' "$TAGS_XML")"
# Cleared: xattr should be absent OR contain empty array
if [[ -z "$TAGS_XML" ]] || ! printf '%s' "$TAGS_XML" | grep -qiE 'Red|Blue|Green|Yellow|Orange|Purple|Gray'; then
  echo "PASS: all tags removed"; exit 0
fi
echo "FAIL: tags still present"; exit 1
