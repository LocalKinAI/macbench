#!/usr/bin/env bash
set -uo pipefail
POST="$(defaults read com.apple.finder FXPreferredViewStyle 2>/dev/null | tr -d '[:space:]"' || echo "")"
echo "post FXPreferredViewStyle: $POST"
if [[ "$POST" == "clmv" ]]; then
  echo "PASS: switched to clmv view"; exit 0
fi
echo "FAIL: expected clmv, got '$POST'"; exit 1
