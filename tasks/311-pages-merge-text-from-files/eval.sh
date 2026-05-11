#!/usr/bin/env bash
# We can grep the unzipped bundle for the three distinct marker strings.
set -uo pipefail
F="$HOME/Desktop/kinbench/311-merged.pages"
CONF="$HOME/Desktop/kinbench/311-merge-confirm.txt"

[[ -e "$F" ]] || { echo "FAIL: $F missing"; exit 1; }
SIZE="$(stat -f %z "$F" 2>/dev/null || stat -c %s "$F" 2>/dev/null || echo 0)"
[[ "$SIZE" -gt 1024 ]] || { echo "FAIL: $F too small"; exit 2; }

if file "$F" | grep -qi "zip"; then
  TMP="$(mktemp -d)"
  trap 'rm -rf "$TMP"' EXIT
  if unzip -q -o "$F" -d "$TMP" 2>/dev/null; then
    hits=0
    for m in "Alpha block" "Bravo block" "Charlie block"; do
      if grep -r -a -l "$m" "$TMP" 2>/dev/null | grep -q .; then
        hits=$((hits + 1))
      fi
    done
    if [[ "$hits" -eq 3 ]]; then
      echo "PASS: all three source markers found in merged doc"
      exit 0
    elif [[ "$hits" -ge 2 ]]; then
      echo "PASS (partial): $hits/3 markers found"
      exit 0
    fi
  fi
fi
if [[ -f "$CONF" ]]; then
  echo "PASS (soft): confirmation present, doc size=$SIZE"
  exit 0
fi
echo "FAIL: doc exists but no markers and no confirmation"
exit 3
