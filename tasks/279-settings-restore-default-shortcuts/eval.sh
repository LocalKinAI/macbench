#!/usr/bin/env bash
# Pass: sentinel key 9999 is absent (means Restore Defaults erased it,
# or agent manually deleted it).
set -uo pipefail
DUMP="$(defaults read com.apple.symbolichotkeys 2>/dev/null || echo '')"
if echo "$DUMP" | grep -q '9999'; then
  echo "FAIL: sentinel shortcut 9999 still present — Restore Defaults not invoked"
  exit 1
fi
echo "PASS: sentinel shortcut absent — Restore Defaults appears successful"
exit 0
