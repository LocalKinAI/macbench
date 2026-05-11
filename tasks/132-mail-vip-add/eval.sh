#!/usr/bin/env bash
# VIPs.plist is TCC-protected. Soft-pass via confirmation file.
set -uo pipefail
F="$HOME/Desktop/kinbench/132-vip-confirm.txt"
if [[ -f "$F" ]]; then
  C="$(/bin/cat "$F" | /usr/bin/tr -d '[:space:]')"
  if [[ -n "$C" ]]; then
    echo "vip confirm content: $C"
    echo "PASS (soft): VIP action confirmed by agent (plist TCC-protected)"
    exit 0
  fi
fi
echo "FAIL: confirmation file missing or empty"
exit 1
