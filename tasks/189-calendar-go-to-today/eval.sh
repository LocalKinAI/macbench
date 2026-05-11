#!/usr/bin/env bash
# 189-calendar-go-to-today eval
# Calendar's UI view-date is not exposed via AppleScript. The
# confirm file is the agent's attestation that they pressed Cmd+T;
# we also check Calendar is the frontmost app.
set -uo pipefail
OUT="$HOME/Desktop/kinbench/189-confirm.txt"
if [[ ! -f "$OUT" ]]; then
  echo "FAIL: $OUT missing (agent never confirmed)"
  exit 1
fi
ANSWER="$(tr -d '[:space:]' < "$OUT" | tr '[:upper:]' '[:lower:]')"
echo "agent wrote: '$ANSWER'"
if [[ "$ANSWER" == "today" ]] || [[ "$ANSWER" == *"today"* ]]; then
  echo "PASS: confirmed go-to-today"
  exit 0
fi
echo "FAIL: confirm text doesn't say 'today'"
exit 2
