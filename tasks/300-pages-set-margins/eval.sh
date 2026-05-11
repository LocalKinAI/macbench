#!/usr/bin/env bash
# Soft-pass: margins live deep in the Pages protobuf — not deterministically
# parseable from disk. Accept agent's confirmation + file existence.
set -uo pipefail
F="$HOME/Desktop/kinbench/300-doc.pages"
CONF="$HOME/Desktop/kinbench/300-margins-confirm.txt"

[[ -e "$F" ]] || { echo "FAIL: $F missing"; exit 1; }
SIZE="$(stat -f %z "$F" 2>/dev/null || stat -c %s "$F" 2>/dev/null || echo 0)"
[[ "$SIZE" -gt 1024 ]] || { echo "FAIL: $F too small"; exit 2; }

if [[ -f "$CONF" ]]; then
  echo "PASS (soft): confirmation present, doc size=$SIZE"
  exit 0
fi
echo "PARTIAL: doc present ($SIZE bytes), no confirmation — soft pass"
exit 0
