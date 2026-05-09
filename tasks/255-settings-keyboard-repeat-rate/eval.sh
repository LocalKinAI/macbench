#!/usr/bin/env bash
set -uo pipefail
POST="$(defaults read -g KeyRepeat 2>/dev/null | tr -d '[:space:]' || echo "6")"
echo "post KeyRepeat: $POST"
# Fastest = 2; passing if < 6
if [[ "$POST" =~ ^[0-9]+$ ]] && (( POST < 6 )); then
  echo "PASS: KeyRepeat set faster ($POST)"; exit 0
fi
echo "FAIL: KeyRepeat not faster (got $POST)"
exit 1
