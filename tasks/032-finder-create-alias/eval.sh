#!/usr/bin/env bash
# Pass: at least one entry in 032-aliases/ that is either
#   - a real Finder alias (has com.apple.FinderInfo xattr with alias bit), OR
#   - a symlink (legitimate substitute)
# AND it resolves to / references the original target.
set -uo pipefail
DIR="$HOME/Desktop/kinbench/032-aliases"
TARGET="$HOME/Desktop/kinbench/032-target.txt"

ENTRIES=$(find "$DIR" -mindepth 1 -maxdepth 1 | wc -l | tr -d ' ')
echo "entries in $DIR: $ENTRIES"
if [[ "$ENTRIES" -lt 1 ]]; then
  echo "FAIL: no alias / link in $DIR"
  exit 1
fi

OK=0
while IFS= read -r f; do
  if [[ -L "$f" ]]; then
    LINK_TARGET="$(readlink "$f")"
    echo "  symlink: $f → $LINK_TARGET"
    if [[ "$LINK_TARGET" == *"032-target.txt" ]]; then OK=1; fi
  else
    # macOS Finder alias detection: file has com.apple.FinderInfo with
    # specific bytes. Easier: check size > 0 and the file has a typical
    # alias signature ("book" magic).
    SIZE=$(stat -f %z "$f" 2>/dev/null || echo 0)
    if [[ "$SIZE" -gt 0 ]] && head -c 4 "$f" | grep -q "book"; then
      echo "  Finder alias: $f"
      OK=1
    fi
  fi
done < <(find "$DIR" -mindepth 1 -maxdepth 1)

if [[ "$OK" -eq 1 ]]; then
  echo "PASS: alias / symlink to original found"
  exit 0
fi
echo "FAIL: file in $DIR but doesn't look like an alias to 032-target.txt"
exit 2
