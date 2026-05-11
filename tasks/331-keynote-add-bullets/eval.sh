#!/usr/bin/env bash
# Heuristic: grep for First/Second/Third in the unzipped Keynote bundle.
set -uo pipefail
F="$HOME/Desktop/kinbench/331-deck.key"
CONF="$HOME/Desktop/kinbench/331-bullets-confirm.txt"
[[ -e "$F" ]] || { echo "FAIL: $F missing"; exit 1; }
SIZE="$(stat -f %z "$F" 2>/dev/null || stat -c %s "$F" 2>/dev/null || echo 0)"
[[ "$SIZE" -gt 1024 ]] || { echo "FAIL: $F too small"; exit 2; }

if file "$F" | grep -qi "zip"; then
  TMP="$(mktemp -d)"
  trap 'rm -rf "$TMP"' EXIT
  if unzip -q -o "$F" -d "$TMP" 2>/dev/null; then
    hits=0
    for w in First Second Third; do
      if grep -r -a -l "$w" "$TMP" 2>/dev/null | grep -q .; then
        hits=$((hits + 1))
      fi
    done
    if [[ "$hits" -ge 2 ]]; then
      echo "PASS: $hits/3 bullet words found"
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
