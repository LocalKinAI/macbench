#!/usr/bin/env bash
set -uo pipefail
F="$HOME/Desktop/kinbench/153-mute-confirm.txt"
if [[ -f "$F" ]] && /usr/bin/grep -q "muted" "$F"; then
  echo "PASS (soft): mute confirmation present"
  exit 0
fi
echo "FAIL: no confirmation"
exit 1
