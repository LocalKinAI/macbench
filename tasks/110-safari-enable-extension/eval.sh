#!/usr/bin/env bash
# Pass: any confirmation file content (agent reports either an
# enabled name or the empty-list case).
set -uo pipefail
F="$HOME/Desktop/kinbench/110-extension-confirm.txt"
if [ -s "$F" ]; then
  CONTENT="$(cat "$F" | tr '[:upper:]' '[:lower:]')"
  case "$CONTENT" in
    *enabled*|*no\ extensions*|*empty*) echo "PASS: $CONTENT"; exit 0 ;;
  esac
fi
echo "FAIL: confirm file missing or unrecognized content"
exit 1
