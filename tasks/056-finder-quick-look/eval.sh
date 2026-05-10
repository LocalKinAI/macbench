#!/usr/bin/env bash
# Quick Look is a transient overlay (qlmanage process is short-lived); the
# eval can't reliably observe it from outside. Soft-pass: target file still
# exists + agent wrote a confirmation file proving it understood + did the action.
set -uo pipefail
TARGET="$HOME/Desktop/kinbench/056-target.txt"
CONFIRM="$HOME/Desktop/kinbench/056-confirm.txt"
[[ -f "$TARGET" ]] || { echo "FAIL: target file deleted"; exit 1; }
[[ -f "$CONFIRM" ]] || { echo "FAIL: confirmation file $CONFIRM missing"; exit 2; }
content="$(/bin/cat "$CONFIRM" | /usr/bin/tr -d '[:space:]')"
echo "confirm content: $content"
if printf '%s' "$content" | /usr/bin/grep -qi "quicklook"; then
  echo "PASS: confirmation written (Quick Look overlay not directly observable)"
  exit 0
fi
echo "FAIL: confirmation file lacks 'quicklook' marker"
exit 3
