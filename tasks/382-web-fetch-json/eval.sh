#!/usr/bin/env bash
# Pass: file is valid JSON with .name=="macbench" and .owner.login
set -uo pipefail
OUT="$HOME/Desktop/kinbench/382-repo.json"
if [[ ! -f "$OUT" ]]; then echo "FAIL: $OUT missing"; exit 1; fi
NAME=$(jq -r '.name // empty' "$OUT" 2>/dev/null)
OWNER=$(jq -r '.owner.login // empty' "$OUT" 2>/dev/null)
echo "name=$NAME owner=$OWNER"
if [[ "$NAME" == "macbench" ]] && [[ "$OWNER" == "LocalKinAI" ]]; then
  echo "PASS"
  exit 0
fi
echo "FAIL: not the expected GitHub repo JSON"
exit 2
