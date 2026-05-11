#!/usr/bin/env bash
# Translation state isn't queryable; accept either path via confirm file.
set -uo pipefail
F="$HOME/Desktop/kinbench/118-translate-confirm.txt"
if [ -s "$F" ]; then
  CONTENT="$(cat "$F" | tr '[:upper:]' '[:lower:]')"
  case "$CONTENT" in
    *translated*|*english*|*not\ available*|*unavailable*) echo "PASS: $CONTENT"; exit 0 ;;
  esac
fi
echo "FAIL: confirm file missing or unrecognized"
exit 1
