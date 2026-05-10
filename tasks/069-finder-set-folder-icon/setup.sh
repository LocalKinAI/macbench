#!/usr/bin/env bash
set -uo pipefail
SANDBOX="$HOME/Desktop/kinbench"
TARGET="$SANDBOX/069-folder"
mkdir -p "$SANDBOX"
/bin/rm -rf "$TARGET"
mkdir -p "$TARGET"
# Drop a tiny PNG image the agent can use as the icon source
SRC_IMG="$SANDBOX/069-icon-source.png"
# 1x1 red PNG (precomputed minimal valid PNG)
/bin/echo -n -e '\x89PNG\r\n\x1a\n\x00\x00\x00\rIHDR\x00\x00\x00\x01\x00\x00\x00\x01\x08\x02\x00\x00\x00\x90wS\xde\x00\x00\x00\x0cIDAT\x08\xd7c\xf8\xcf\xc0\x00\x00\x00\x03\x00\x01\x5b\x88\xb1\x18\x00\x00\x00\x00IEND\xaeB`\x82' > "$SRC_IMG"
echo "→ folder $TARGET ready (kHasCustomIcon flag NOT set yet); icon source at $SRC_IMG"
