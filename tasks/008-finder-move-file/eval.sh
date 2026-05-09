#!/usr/bin/env bash
set -uo pipefail
SRC="$HOME/Desktop/kinbench/008-src/file.txt"
DST="$HOME/Desktop/kinbench/008-dst/file.txt"
if [[ -f "$DST" && ! -f "$SRC" ]]; then
  echo "PASS: file moved (in dst, absent from src)"
  exit 0
fi
echo "FAIL: src=$([[ -f "$SRC" ]] && echo present || echo absent), dst=$([[ -f "$DST" ]] && echo present || echo absent)"
exit 1
