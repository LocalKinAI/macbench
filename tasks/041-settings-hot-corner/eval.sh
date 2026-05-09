#!/usr/bin/env bash
set -uo pipefail
POST="$(defaults read com.apple.dock wvous-br-corner 2>/dev/null || echo "0")"
echo "post bottom-right corner: $POST  (2 = Mission Control)"
if [[ "$POST" == "2" ]]; then
  echo "PASS: hot corner set to Mission Control"
  exit 0
fi
echo "FAIL: expected 2, got $POST"
exit 1
