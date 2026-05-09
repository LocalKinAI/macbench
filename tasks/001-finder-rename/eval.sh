#!/usr/bin/env bash
# 001-finder-rename eval
#
# Pass criteria:
#   - 001-output.txt exists in sandbox
#   - 001-input.txt no longer exists (real rename, not copy)
#
# Returns: 0 on pass, non-zero with reason on fail.

set -uo pipefail
SANDBOX="$HOME/Desktop/kinbench"

if [[ ! -f "$SANDBOX/001-output.txt" ]]; then
  echo "FAIL: $SANDBOX/001-output.txt missing"
  exit 1
fi

if [[ -f "$SANDBOX/001-input.txt" ]]; then
  echo "FAIL: $SANDBOX/001-input.txt still exists (agent copied instead of renaming)"
  exit 2
fi

echo "PASS: rename observed"
exit 0
