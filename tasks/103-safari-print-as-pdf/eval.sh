#!/usr/bin/env bash
set -uo pipefail
F="$HOME/Desktop/kinbench/103-page.pdf"
[[ -f "$F" ]] || { echo "FAIL: $F missing"; exit 1; }
file "$F" | grep -qi "PDF document" || { echo "FAIL: not PDF"; exit 2; }
SIZE=$(stat -f %z "$F" 2>/dev/null || echo 0)
[[ "$SIZE" -gt 5000 ]] || { echo "FAIL: too small"; exit 3; }
echo "PASS: PDF saved ($SIZE bytes)"
