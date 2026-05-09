#!/usr/bin/env bash
set -uo pipefail
LINK="$HOME/Desktop/kinbench/077-link"
TARGET="$HOME/Desktop/kinbench/077-target.txt"
[[ -L "$LINK" ]] || { echo "FAIL: $LINK is not a symlink"; exit 1; }
LT="$(readlink "$LINK")"
echo "symlink target: $LT"
# Accept either absolute or basename-relative as long as it points at our target.
case "$LT" in
  *077-target.txt) echo "PASS: symlink points to 077-target.txt"; exit 0 ;;
  *) echo "FAIL: symlink target '$LT' doesn't reference 077-target.txt"; exit 2 ;;
esac
