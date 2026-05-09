#!/usr/bin/env bash
set -uo pipefail
SRC="$HOME/Desktop/kinbench/084-source"
ARCHIVE="$HOME/Desktop/kinbench/084-archive"

OLD_IN_SRC=0
for f in old-1 old-2 old-3; do [[ -f "$SRC/${f}.txt" ]] && OLD_IN_SRC=$((OLD_IN_SRC+1)); done

OLD_IN_ARCHIVE=0
for f in old-1 old-2 old-3; do [[ -f "$ARCHIVE/${f}.txt" ]] && OLD_IN_ARCHIVE=$((OLD_IN_ARCHIVE+1)); done

NEW_IN_SRC=0
for f in new-1 new-2; do [[ -f "$SRC/${f}.txt" ]] && NEW_IN_SRC=$((NEW_IN_SRC+1)); done

echo "old in src=$OLD_IN_SRC, old in archive=$OLD_IN_ARCHIVE, new in src=$NEW_IN_SRC"

if [[ "$OLD_IN_SRC" -eq 0 && "$OLD_IN_ARCHIVE" -eq 3 && "$NEW_IN_SRC" -eq 2 ]]; then
  echo "PASS: 3 old files archived, 2 new files left alone"
  exit 0
fi
echo "FAIL: expected (0, 3, 2)"
exit 1
