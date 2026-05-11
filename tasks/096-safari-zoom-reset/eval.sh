#!/usr/bin/env bash
set -uo pipefail
F="$HOME/Desktop/kinbench/096-zoom-reset.txt"
if [ ! -s "$F" ]; then
  echo "FAIL: $F missing or empty"
  exit 1
fi
CONTENT="$(cat "$F" | tr '[:upper:]' '[:lower:]')"
echo "reset artifact: $CONTENT"
case "$CONTENT" in
  *reset*|*100*) echo "PASS"; exit 0 ;;
esac
echo "FAIL: artifact lacks reset/100 indication"
exit 2
