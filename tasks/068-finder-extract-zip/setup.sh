#!/usr/bin/env bash
set -euo pipefail
SANDBOX="$HOME/Desktop/kinbench"
mkdir -p "$SANDBOX"
SRC="$SANDBOX/068-bundle.zip"
DST="$SANDBOX/068-extracted"
rm -rf "$DST" "$SRC"
# Build a known archive with 3 files
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
for x in alpha beta gamma; do
  printf '%s body\n' "$x" > "$TMP/${x}.txt"
done
(cd "$TMP" && zip -q -r "$SRC" .)
mkdir -p "$DST"
echo "→ wrote $SRC, empty $DST/"
