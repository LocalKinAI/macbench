#!/usr/bin/env bash
# Pass: a .savedSearch file matching our title exists in ~/Library/Saved Searches.
# Sidebar visibility is harder to verify; the file's existence is the
# canonical signal that the smart folder was created and saved.
set -uo pipefail
SAVED="$HOME/Library/Saved Searches"
if [[ -f "$SAVED/KinBench Today.savedSearch" ]]; then
  echo "PASS: smart folder file present at $SAVED/KinBench Today.savedSearch"
  exit 0
fi
# Tolerate slight name variations (different capitalization, dashes).
MATCH=$(find "$SAVED" -maxdepth 1 -iname '*kinbench*today*.savedSearch' 2>/dev/null | head -1)
if [[ -n "$MATCH" ]]; then
  echo "PASS (fuzzy match): $MATCH"
  exit 0
fi
echo "FAIL: no matching .savedSearch file in $SAVED"
ls "$SAVED" 2>/dev/null | head -10
exit 1
