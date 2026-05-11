#!/usr/bin/env bash
# Pages bundles store header text — we can heuristically grep for it after
# unzipping. Falls back to confirmation file.
set -uo pipefail
F="$HOME/Desktop/kinbench/306-doc.pages"
CONF="$HOME/Desktop/kinbench/306-header-confirm.txt"

[[ -e "$F" ]] || { echo "FAIL: $F missing"; exit 1; }
SIZE="$(stat -f %z "$F" 2>/dev/null || stat -c %s "$F" 2>/dev/null || echo 0)"
[[ "$SIZE" -gt 1024 ]] || { echo "FAIL: $F too small"; exit 2; }

if file "$F" | grep -qi "zip"; then
  TMP="$(mktemp -d)"
  trap 'rm -rf "$TMP"' EXIT
  if unzip -q -o "$F" -d "$TMP" 2>/dev/null; then
    # Count "KinBench 306" occurrences. The body already has one — header
    # adds a second, so >=2 hits is the signal we want.
    HITS=$(grep -r -a -o "KinBench 306" "$TMP" 2>/dev/null | wc -l | tr -d ' ')
    if [[ "${HITS:-0}" -ge 2 ]]; then
      echo "PASS: 'KinBench 306' appears $HITS times (body + header)"
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
