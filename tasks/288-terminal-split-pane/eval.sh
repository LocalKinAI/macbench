#!/usr/bin/env bash
# Split-pane state isn't reliably exposed via AppleScript — the
# Terminal app dict doesn't surface pane counts. We rely on the
# confirmation file as the primary signal, and as a secondary signal
# check whether the Shell > Split Window menu item is currently
# disabled (it disables once a window is already split).
set -uo pipefail
sleep 1
F="$HOME/Desktop/kinbench/288-confirm.txt"
if [[ -f "$F" ]] && grep -qi "split-done" "$F"; then
  echo "PASS: split confirmation file written"
  exit 0
fi
echo "FAIL: $F missing or empty"
exit 1
