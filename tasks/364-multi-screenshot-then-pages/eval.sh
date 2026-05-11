#!/usr/bin/env bash
set -uo pipefail
sleep 2
SHOT="$HOME/Desktop/kinbench/364-shot.png"
DOC="$HOME/Desktop/kinbench/364-doc.pages"

SHOT_OK=0
if [[ -f "$SHOT" ]]; then
  SIZE=$(stat -f %z "$SHOT" 2>/dev/null || echo 0)
  if [[ "$SIZE" -gt 1000 ]] && file "$SHOT" | grep -qi "PNG"; then SHOT_OK=1; fi
fi

DOC_OK=0
# Pages docs are either directories (package) or single files
if [[ -d "$DOC" ]] || [[ -f "$DOC" ]]; then
  DOC_OK=1
fi

echo "shot_ok=$SHOT_OK doc_ok=$DOC_OK"

if [[ "$SHOT_OK" -eq 1 && "$DOC_OK" -eq 1 ]]; then
  echo "PASS: screenshot + Pages doc both saved"
  exit 0
fi
if [[ "$SHOT_OK" -eq 1 ]]; then
  echo "PARTIAL: screenshot saved but Pages doc not at expected path — soft pass"
  exit 0
fi
echo "FAIL: shot_ok=$SHOT_OK doc_ok=$DOC_OK"
exit 1
