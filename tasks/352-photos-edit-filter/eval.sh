#!/usr/bin/env bash
set -uo pipefail
F="$HOME/Desktop/kinbench/352-confirm.txt"
[[ -f "$F" ]] && { echo "PASS (soft): filter confirmed"; exit 0; }
echo "FAIL: no confirmation file"
exit 1
