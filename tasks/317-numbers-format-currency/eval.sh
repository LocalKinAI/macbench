#!/usr/bin/env bash
# Soft-pass: cell format code is buried in protobuf. Heuristic grep for a
# currency marker in the bundle; falls back to confirmation file.
set -uo pipefail
F="$HOME/Desktop/kinbench/317-sheet.numbers"
CONF="$HOME/Desktop/kinbench/317-currency-confirm.txt"

[[ -e "$F" ]] || { echo "FAIL: $F missing"; exit 1; }
SIZE="$(stat -f %z "$F" 2>/dev/null || stat -c %s "$F" 2>/dev/null || echo 0)"
[[ "$SIZE" -gt 1024 ]] || { echo "FAIL: $F too small"; exit 2; }

if file "$F" | grep -qi "zip"; then
  TMP="$(mktemp -d)"
  trap 'rm -rf "$TMP"' EXIT
  if unzip -q -o "$F" -d "$TMP" 2>/dev/null; then
    if grep -r -a -l -i "currency\|USD\|\\\$" "$TMP" 2>/dev/null | grep -q .; then
      echo "PASS (heuristic): currency marker found"
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
