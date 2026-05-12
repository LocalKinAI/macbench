#!/usr/bin/env bash
# Pass: JSON array with ≥3 entries that have title + url fields
set -uo pipefail
OUT="$HOME/Desktop/kinbench/381-results.json"
if [[ ! -f "$OUT" ]]; then echo "FAIL: $OUT missing"; exit 1; fi
# Try parsing as JSON; count entries with both title and url
N=$(jq -r '. | map(select(.title and .url)) | length' "$OUT" 2>/dev/null)
if [[ -z "$N" ]]; then echo "FAIL: not valid JSON array"; exit 2; fi
echo "found: $N results"
if [[ "$N" -ge 3 ]]; then
  echo "PASS"
  exit 0
fi
echo "FAIL: expected ≥3 hits, got $N"
exit 3
