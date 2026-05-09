#!/usr/bin/env bash
set -uo pipefail
F="$HOME/Desktop/kinbench/297-diagnose.txt"
[[ -f "$F" ]] || { echo "FAIL: $F missing"; exit 1; }
SIZE=$(stat -f %z "$F" 2>/dev/null || stat -c %s "$F" 2>/dev/null || echo 0)
[[ "$SIZE" -gt 50 ]] || { echo "FAIL: file too small ($SIZE)"; exit 2; }
# Should have ping-shaped output (PING, bytes, time=) or traceroute (hops)
if grep -qE 'PING|bytes from|time=|traceroute|^[ 0-9]+\s+[a-z0-9.-]+' "$F"; then
  echo "PASS: looks like network diagnosis output"
  exit 0
fi
echo "FAIL: doesn't look like ping/traceroute output"
exit 3
