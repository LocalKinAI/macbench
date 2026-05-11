#!/usr/bin/env bash
set -uo pipefail
F="$HOME/Desktop/kinbench/347-confirm.txt"
[[ -f "$F" ]] && { echo "PASS (soft): confirm written"; exit 0; }
# Fallback: also accept if Photos process is running (best-effort)
if pgrep -x Photos >/dev/null 2>&1; then
  echo "PASS (soft): Photos running"
  exit 0
fi
echo "FAIL: no confirmation file and Photos not running"
exit 1
