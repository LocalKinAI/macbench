#!/usr/bin/env bash
# Plant 3 old files (mtime 60 days ago) + 2 new files. Eval expects
# only the old ones moved to archive.
set -uo pipefail
SRC="$HOME/Desktop/kinbench/084-source"
ARCHIVE="$HOME/Desktop/kinbench/084-archive"
rm -rf "$SRC" "$ARCHIVE"
mkdir -p "$SRC" "$ARCHIVE"
# Old files (60 days ago)
for f in old-1 old-2 old-3; do
  printf 'old\n' > "$SRC/${f}.txt"
  touch -t "$(date -v -60d "+%Y%m%d%H%M")" "$SRC/${f}.txt"
done
# New files (today)
for f in new-1 new-2; do
  printf 'new\n' > "$SRC/${f}.txt"
done
echo "→ 3 old (60d) + 2 new in $SRC; empty $ARCHIVE"
