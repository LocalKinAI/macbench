#!/usr/bin/env bash
set -uo pipefail
F="$HOME/Desktop/kinbench/182-note.pdf"
[[ -f "$F" ]] || { echo "FAIL: $F missing"; exit 1; }
file "$F" | grep -qi "PDF document" || { echo "FAIL: not PDF"; exit 2; }
echo "PASS"
