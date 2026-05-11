#!/usr/bin/env bash
set -uo pipefail
sleep 2
if pgrep -x Maps >/dev/null 2>&1; then
  echo "PASS: Maps running (directions URL handler invoked)"
  exit 0
fi
echo "FAIL: Maps not running"
exit 1
