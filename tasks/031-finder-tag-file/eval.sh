#!/usr/bin/env bash
# Pass: file's _kMDItemUserTags xattr contains "Red".
# macOS stores tags as a binary plist in xattr; xattr -p shows
# hex but we can convert via plutil to xml1 then grep.
set -uo pipefail
F="$HOME/Desktop/kinbench/031-tag-me.txt"
if [[ ! -f "$F" ]]; then
  echo "FAIL: $F missing"
  exit 1
fi
TAGS_XML="$(xattr -p com.apple.metadata:_kMDItemUserTags "$F" 2>/dev/null \
  | xxd -r -p \
  | plutil -convert xml1 -o - - 2>/dev/null || true)"
echo "tags xml:"
printf '%s\n' "$TAGS_XML" | head -20

if printf '%s' "$TAGS_XML" | grep -qi "Red"; then
  echo "PASS: Red tag applied"
  exit 0
fi
echo "FAIL: Red tag not present in xattr"
exit 2
