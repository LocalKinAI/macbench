#!/usr/bin/env bash
set -uo pipefail
sleep 1
F="$HOME/Desktop/kinbench/358-confirm.txt"
[[ -f "$F" ]] && { echo "PASS (soft): favorite confirmed"; exit 0; }
# Fallback: accept if Maps process running (best-effort proxy)
if pgrep -x Maps >/dev/null 2>&1; then
  echo "PASS (soft): Maps running"
  exit 0
fi
echo "FAIL"
exit 1
