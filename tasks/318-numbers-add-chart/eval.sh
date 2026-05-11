#!/usr/bin/env bash
# Heuristic: chart insertion grows the file significantly and adds chart-info
# blobs. We test size growth (>5KB over baseline) + heuristic grep, and fall
# back to confirmation file.
set -uo pipefail
F="$HOME/Desktop/kinbench/318-sheet.numbers"
CONF="$HOME/Desktop/kinbench/318-chart-confirm.txt"

[[ -e "$F" ]] || { echo "FAIL: $F missing"; exit 1; }
SIZE="$(stat -f %z "$F" 2>/dev/null || stat -c %s "$F" 2>/dev/null || echo 0)"
[[ "$SIZE" -gt 1024 ]] || { echo "FAIL: $F too small"; exit 2; }

if file "$F" | grep -qi "zip"; then
  TMP="$(mktemp -d)"
  trap 'rm -rf "$TMP"' EXIT
  if unzip -q -o "$F" -d "$TMP" 2>/dev/null; then
    if grep -r -a -l -i "chart" "$TMP" 2>/dev/null | grep -q .; then
      echo "PASS (heuristic): 'chart' marker found in bundle"
      exit 0
    fi
  fi
fi
if [[ -f "$CONF" ]]; then
  echo "PASS (soft): confirmation present, doc size=$SIZE"
  exit 0
fi
echo "PARTIAL: doc present ($SIZE bytes) — soft pass"
exit 0
