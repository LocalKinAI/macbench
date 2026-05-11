#!/usr/bin/env bash
# 091 eval: Bookmarks.plist is TCC-blocked; we soft-pass on the agent's
# confirmation file (preferred) and double-check by trying to grep the
# bookmark plist (hard pass if accessible).
set -uo pipefail
CONFIRM="$HOME/Desktop/kinbench/091-bookmark-confirm.txt"

# Hard path: try to read the bookmarks plist.
for plist in \
  "$HOME/Library/Containers/com.apple.Safari/Data/Library/Safari/Bookmarks.plist" \
  "$HOME/Library/Safari/Bookmarks.plist"; do
  if [ -f "$plist" ]; then
    DUMP="$(plutil -convert xml1 -o - "$plist" 2>/dev/null || true)"
    if printf '%s' "$DUMP" | grep -qi "apple.com"; then
      echo "PASS: apple.com bookmark in plist"
      exit 0
    fi
  fi
done

# Soft path: agent-written confirmation file.
if [ -s "$CONFIRM" ] && grep -qi "apple.com" "$CONFIRM"; then
  echo "PASS: soft (agent confirmation file present)"
  exit 0
fi

echo "FAIL: neither plist read nor confirmation file written"
exit 1
