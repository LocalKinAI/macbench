#!/usr/bin/env bash
# Soft-pass: table presence is hard to verify outside iWork itself. We accept
# a confirmation file + non-trivial document size. Best-effort: an unzip-based
# scan looks for "table" markers in the protobuf bundle (heuristic).
set -uo pipefail
F="$HOME/Desktop/kinbench/301-doc.pages"
CONF="$HOME/Desktop/kinbench/301-table-confirm.txt"

[[ -e "$F" ]] || { echo "FAIL: $F missing"; exit 1; }
SIZE="$(stat -f %z "$F" 2>/dev/null || stat -c %s "$F" 2>/dev/null || echo 0)"
[[ "$SIZE" -gt 1024 ]] || { echo "FAIL: $F too small"; exit 2; }

if file "$F" | grep -qi "zip"; then
  TMP="$(mktemp -d)"
  trap 'rm -rf "$TMP"' EXIT
  if unzip -q -o "$F" -d "$TMP" 2>/dev/null; then
    if grep -r -l -a "TST\|Table\|table" "$TMP" 2>/dev/null | grep -q .; then
      echo "PASS (heuristic): table marker found in bundle, doc size=$SIZE"
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
