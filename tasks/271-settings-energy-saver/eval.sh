#!/usr/bin/env bash
set -uo pipefail
POST="$(pmset -g | awk '/^ displaysleep/{print $2}' || echo "?")"
echo "post displaysleep: $POST min"
if [[ "$POST" == "5" ]]; then
  echo "PASS: displaysleep is 5 min"; exit 0
fi
echo "FAIL: expected 5, got $POST"
exit 1
