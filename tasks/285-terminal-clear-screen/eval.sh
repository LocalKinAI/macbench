#!/usr/bin/env bash
# Pass: confirmation file written. Whether the screen actually got
# cleared isn't reliably observable from outside Terminal's render
# buffer — we rely on the confirmation token from a successful run.
set -uo pipefail
F="$HOME/Desktop/kinbench/285-confirm.txt"
[[ -f "$F" ]] || { echo "FAIL: $F missing"; exit 1; }
if grep -qi "screen-cleared" "$F"; then
  echo "PASS: clear-screen confirmation present"
  exit 0
fi
echo "FAIL: $F doesn't contain 'screen-cleared'"
exit 2
