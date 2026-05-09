#!/usr/bin/env bash
set -uo pipefail
F="$HOME/Desktop/kinbench/278-defaults.plist"
[[ -f "$F" ]] || { echo "FAIL: $F missing"; exit 1; }
SIZE=$(stat -f %z "$F" 2>/dev/null || stat -c %s "$F" 2>/dev/null || echo 0)
[[ "$SIZE" -gt 1000 ]] || { echo "FAIL: file too small ($SIZE)"; exit 2; }
echo "PASS: $F ($SIZE bytes)"; exit 0
