#!/usr/bin/env bash
set -uo pipefail
CONFIRM="$HOME/Desktop/kinbench/101-bookmark-folder-confirm.txt"

for plist in \
  "$HOME/Library/Containers/com.apple.Safari/Data/Library/Safari/Bookmarks.plist" \
  "$HOME/Library/Safari/Bookmarks.plist"; do
  if [ -f "$plist" ]; then
    DUMP="$(plutil -convert xml1 -o - "$plist" 2>/dev/null || true)"
    if printf '%s' "$DUMP" | grep -qi "KinBench" && printf '%s' "$DUMP" | grep -qi "apple.com"; then
      echo "PASS: KinBench folder + apple.com in plist"
      exit 0
    fi
  fi
done

if [ -s "$CONFIRM" ] && grep -qi "kinbench\|apple" "$CONFIRM"; then
  echo "PASS: soft confirmation"
  exit 0
fi

echo "FAIL: KinBench folder or apple.com bookmark not detected"
exit 1
