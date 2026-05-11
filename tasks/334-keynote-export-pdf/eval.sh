#!/usr/bin/env bash
# Real verification: output must be a valid PDF with non-trivial size.
set -uo pipefail
F="$HOME/Desktop/kinbench/334-deck.pdf"
[[ -f "$F" ]] || { echo "FAIL: $F missing"; exit 1; }
file "$F" | grep -qi "PDF document" || { echo "FAIL: not a PDF"; exit 2; }
SIZE=$(stat -f %z "$F" 2>/dev/null || echo 0)
[[ "$SIZE" -gt 1000 ]] || { echo "FAIL: PDF too small ($SIZE)"; exit 3; }
echo "PASS: PDF exported ($SIZE bytes)"
