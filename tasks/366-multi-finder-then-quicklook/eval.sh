#!/usr/bin/env bash
set -uo pipefail
sleep 1
SHOT="$HOME/Desktop/kinbench/366-shot.png"
SHOT_OK=0
if [[ -f "$SHOT" ]]; then
  SIZE=$(stat -f %z "$SHOT" 2>/dev/null || echo 0)
  if [[ "$SIZE" -gt 1000 ]] && file "$SHOT" | grep -qi "PNG"; then SHOT_OK=1; fi
fi

# Bonus signal: Preview running
PREVIEW_RUN="$(pgrep -x Preview >/dev/null 2>&1 && echo 1 || echo 0)"
echo "shot_ok=$SHOT_OK preview_running=$PREVIEW_RUN"

if [[ "$SHOT_OK" -eq 1 ]]; then
  if [[ "$PREVIEW_RUN" -eq 1 ]]; then
    echo "PASS: screenshot + Preview running"
    exit 0
  fi
  echo "PASS (soft): screenshot saved; Preview may have been closed by agent"
  exit 0
fi
echo "FAIL: screenshot missing or invalid"
exit 1
