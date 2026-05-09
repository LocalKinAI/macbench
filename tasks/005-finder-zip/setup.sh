#!/usr/bin/env bash
# 005-finder-zip setup
#
# Create three plaintext files and remove any prior archive.

set -euo pipefail
SANDBOX="$HOME/Desktop/kinbench"
mkdir -p "$SANDBOX/005-archive"
rm -f "$SANDBOX/005-archive.zip"

for f in a b c; do
  printf '%s file content\n' "$f" > "$SANDBOX/005-archive/${f}.txt"
done

echo "→ wrote $SANDBOX/005-archive/{a,b,c}.txt"
