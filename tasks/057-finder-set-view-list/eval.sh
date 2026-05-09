#!/usr/bin/env bash
set -uo pipefail
POST="$(defaults read com.apple.finder FXPreferredViewStyle 2>/dev/null | tr -d '[:space:]"' || echo "")"
echo "post FXPreferredViewStyle: $POST"
if [[ "$POST" == "Nlsv" ]]; then
  echo "PASS: switched to Nlsv view"; exit 0
fi
echo "FAIL: expected Nlsv, got '$POST'"; exit 1
