#!/usr/bin/env bash
set -uo pipefail
DIR="$HOME/Desktop/kinbench/086-photos"
HEIC_LEFT=$(find "$DIR" -name '*.heic' | wc -l | tr -d ' ')
JPG_NEW=$(find "$DIR" -name 'shot-*.jpg' | wc -l | tr -d ' ')
EXISTING=$(find "$DIR" -name 'existing.jpg' | wc -l | tr -d ' ')
echo "heic remaining=$HEIC_LEFT, shot-*.jpg=$JPG_NEW, existing.jpg=$EXISTING"
if [[ "$HEIC_LEFT" -eq 0 && "$JPG_NEW" -eq 3 && "$EXISTING" -eq 1 ]]; then
  echo "PASS: 3 heic→jpg, distractor untouched"
  exit 0
fi
echo "FAIL: expected 0 heic, 3 shot-*.jpg, 1 existing.jpg"
exit 1
