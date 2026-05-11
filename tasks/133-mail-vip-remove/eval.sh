#!/usr/bin/env bash
set -uo pipefail
F="$HOME/Desktop/kinbench/133-vip-remove-confirm.txt"
if [[ -f "$F" ]] && /usr/bin/grep -q "vip-removed" "$F"; then
  echo "PASS (soft): VIP-remove confirmation present"
  exit 0
fi
echo "FAIL: confirmation file missing"
exit 1
