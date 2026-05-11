#!/usr/bin/env bash
# Pass: file exists, contains Netscape bookmark format markers.
set -uo pipefail
F="$HOME/Desktop/kinbench/123-bookmarks.html"
if [ ! -s "$F" ]; then
  echo "FAIL: $F missing or empty"
  exit 1
fi
SIZE=$(stat -f %z "$F" 2>/dev/null || echo 0)
echo "size: $SIZE bytes"
if [ "$SIZE" -lt 100 ]; then
  echo "FAIL: file too small"
  exit 2
fi
if grep -qi "NETSCAPE-Bookmark\|<DT>\|<TITLE>Bookmarks" "$F"; then
  echo "PASS: Netscape bookmark file"
  exit 0
fi
echo "FAIL: file doesn't look like a bookmarks export"
exit 3
