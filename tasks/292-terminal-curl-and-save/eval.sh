#!/usr/bin/env bash
set -uo pipefail
F="$HOME/Desktop/kinbench/292-page.html"
[[ -f "$F" ]] || { echo "FAIL: $F missing"; exit 1; }
SIZE=$(stat -f %z "$F" 2>/dev/null || stat -c %s "$F" 2>/dev/null || echo 0)
[[ "$SIZE" -gt 100 ]] || { echo "FAIL: file too small ($SIZE bytes)"; exit 2; }
# example.com response should contain "Example Domain" in title
if grep -qi "Example Domain" "$F"; then
  echo "PASS: example.com response captured"
  exit 0
fi
echo "FAIL: doesn't look like example.com content"
exit 3
