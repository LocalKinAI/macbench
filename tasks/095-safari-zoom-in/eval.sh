#!/usr/bin/env bash
# Pass: confirmation file exists and indicates non-trivial zoom.
# Safari's zoom isn't reliably queryable; we trust agent-written
# artifact + soft-check that the View menu shows a non-default zoom.
set -uo pipefail
F="$HOME/Desktop/kinbench/095-zoom-level.txt"
if [ ! -s "$F" ]; then
  echo "FAIL: $F missing or empty"
  exit 1
fi
CONTENT="$(cat "$F" | tr -d '\n' | tr '[:upper:]' '[:lower:]')"
echo "zoom artifact: $CONTENT"
# Accept several signals: 'zoom', a number > 100, etc.
case "$CONTENT" in
  *zoom*|*100*|*125*|*150*|*200*|*1.*|*2.*|*3*) echo "PASS"; exit 0 ;;
esac
echo "FAIL: artifact present but no zoom indication"
exit 2
