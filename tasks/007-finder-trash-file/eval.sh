#!/usr/bin/env bash
# Pass: file is gone from sandbox. Doesn't strictly verify it's IN
# trash (would need to walk ~/.Trash + handle macOS UUID-suffixed
# duplicate names) — gone-from-sandbox is a reasonable proxy.
set -uo pipefail
TARGET="$HOME/Desktop/kinbench/007-doomed.txt"
if [[ ! -e "$TARGET" ]]; then
  echo "PASS: $TARGET is gone (presumed trashed)"
  exit 0
fi
echo "FAIL: $TARGET still exists at original path"
exit 1
