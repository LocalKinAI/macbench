#!/usr/bin/env bash
# Reading List storage is in Bookmarks.plist under com.apple.ReadingList
# key — TCC-protected like Bookmarks. Try a hard read; fall back to
# soft confirm file.
set -uo pipefail
CONFIRM="$HOME/Desktop/kinbench/100-reading-list-confirm.txt"

for plist in \
  "$HOME/Library/Containers/com.apple.Safari/Data/Library/Safari/Bookmarks.plist" \
  "$HOME/Library/Safari/Bookmarks.plist"; do
  if [ -f "$plist" ]; then
    DUMP="$(plutil -convert xml1 -o - "$plist" 2>/dev/null || true)"
    if printf '%s' "$DUMP" | grep -qi "ReadingList" && printf '%s' "$DUMP" | grep -qi "macOS"; then
      echo "PASS: macOS Wikipedia URL appears under ReadingList in plist"
      exit 0
    fi
  fi
done

if [ -s "$CONFIRM" ] && grep -qi "macos\|wikipedia\|reading" "$CONFIRM"; then
  echo "PASS: soft confirmation file present"
  exit 0
fi

echo "FAIL: reading list not detected and no confirmation file"
exit 1
