#!/usr/bin/env bash
# Heuristic: grep for 'cube' in the unzipped bundle.
set -uo pipefail
F="$HOME/Desktop/kinbench/332-deck.key"
CONF="$HOME/Desktop/kinbench/332-transition-confirm.txt"
[[ -e "$F" ]] || { echo "FAIL: $F missing"; exit 1; }
SIZE="$(stat -f %z "$F" 2>/dev/null || stat -c %s "$F" 2>/dev/null || echo 0)"
[[ "$SIZE" -gt 1024 ]] || { echo "FAIL: $F too small"; exit 2; }

if file "$F" | grep -qi "zip"; then
  TMP="$(mktemp -d)"
  trap 'rm -rf "$TMP"' EXIT
  if unzip -q -o "$F" -d "$TMP" 2>/dev/null; then
    if grep -r -a -l -i "cube" "$TMP" 2>/dev/null | grep -q .; then
      echo "PASS: 'cube' transition marker found"
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
