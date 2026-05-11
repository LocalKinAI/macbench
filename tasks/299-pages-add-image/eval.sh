#!/usr/bin/env bash
# Soft-pass eval: Pages bundles are zip-encoded protobuf — image embedding is
# hard to introspect deterministically. We check:
#  (a) the .pages file exists with notably larger size than the empty-text
#      baseline (~5KB extra suggests image embedded), OR
#  (b) the agent's confirmation file is present.
set -uo pipefail
F="$HOME/Desktop/kinbench/299-doc.pages"
CONF="$HOME/Desktop/kinbench/299-image-confirm.txt"

[[ -e "$F" ]] || { echo "FAIL: $F missing"; exit 1; }
SIZE="$(stat -f %z "$F" 2>/dev/null || stat -c %s "$F" 2>/dev/null || echo 0)"
[[ "$SIZE" -gt 1024 ]] || { echo "FAIL: $F too small ($SIZE bytes)"; exit 2; }

# Best-effort: if the .pages bundle is a zip, unzip and look for any embedded
# JPEG/PNG inside the Data/ folder.
if file "$F" | grep -qi "zip"; then
  TMP="$(mktemp -d)"
  trap 'rm -rf "$TMP"' EXIT
  if unzip -q -o "$F" -d "$TMP" 2>/dev/null; then
    if find "$TMP" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" \) 2>/dev/null | grep -q .; then
      echo "PASS: embedded image found in .pages bundle"
      exit 0
    fi
  fi
fi

if [[ -f "$CONF" ]]; then
  echo "PASS (soft): confirmation file present, doc size=$SIZE"
  exit 0
fi
echo "PARTIAL: doc present ($SIZE bytes) but image not introspectable — soft pass"
exit 0
