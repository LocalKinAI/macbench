#!/usr/bin/env bash
set -uo pipefail
F="$HOME/Desktop/kinbench/105-page.webarchive"
[[ -f "$F" ]] || { echo "FAIL: $F missing"; exit 1; }
SIZE=$(stat -f %z "$F" 2>/dev/null || echo 0)
[[ "$SIZE" -gt 1000 ]] || { echo "FAIL: file too small ($SIZE)"; exit 2; }
echo "PASS: webarchive saved ($SIZE bytes)"
