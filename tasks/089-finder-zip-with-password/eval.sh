#!/usr/bin/env bash
set -uo pipefail
ZIP="$HOME/Desktop/kinbench/089-secret.zip"
[[ -f "$ZIP" ]] || { echo "FAIL: $ZIP missing"; exit 1; }
# Try to unzip without a password — should fail
if unzip -q -t "$ZIP" 2>/dev/null; then
  echo "FAIL: zip is readable without password (not encrypted)"
  exit 2
fi
# Try with the documented password
if unzip -P kinbench -q -t "$ZIP" 2>/dev/null; then
  echo "PASS: zip is password-protected with 'kinbench'"
  exit 0
fi
echo "FAIL: unzip with -P kinbench failed (wrong password or other issue)"
exit 3
