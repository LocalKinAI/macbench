#!/usr/bin/env bash
set -uo pipefail
F="$HOME/Desktop/kinbench/296-kill.txt"
[[ -f "$F" ]] || { echo "FAIL: $F missing"; exit 1; }
CONTENT="$(cat "$F")"
echo "agent wrote: $CONTENT"
# TextEdit should NOT be running anymore
if pgrep -x TextEdit >/dev/null 2>&1; then
  echo "FAIL: TextEdit still running"
  exit 2
fi
# Report should mention 'killed' or contain a PID
if grep -qiE 'killed|PID' "$F"; then
  echo "PASS: TextEdit killed + report written"
  exit 0
fi
echo "PASS (lenient): TextEdit not running, report present"
exit 0
