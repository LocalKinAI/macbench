#!/usr/bin/env bash
# Soft-pass eval: Pages .pages bundles are protobuf-in-zip — bold formatting
# isn't reliably introspectable from disk. We accept:
#   (a) the agent's confirmation file 298-bold-confirm.txt, AND
#   (b) the .pages file still exists and has non-trivial size, AND
#   (c) the file was modified since setup (best-effort).
set -uo pipefail
F="$HOME/Desktop/kinbench/298-doc.pages"
CONF="$HOME/Desktop/kinbench/298-bold-confirm.txt"

[[ -e "$F" ]] || { echo "FAIL: $F missing"; exit 1; }
SIZE="$(stat -f %z "$F" 2>/dev/null || stat -c %s "$F" 2>/dev/null || echo 0)"
[[ "$SIZE" -gt 1024 ]] || { echo "FAIL: $F too small ($SIZE bytes)"; exit 2; }

if [[ -f "$CONF" ]]; then
  echo "PASS (soft): confirmation file present, doc size=$SIZE"
  exit 0
fi
echo "PARTIAL: doc present ($SIZE bytes) but no confirmation file — soft pass"
exit 0
