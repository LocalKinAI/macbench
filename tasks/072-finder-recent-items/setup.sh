#!/usr/bin/env bash
set -uo pipefail
SANDBOX="$HOME/Desktop/kinbench"
mkdir -p "$SANDBOX"
TARGET="$SANDBOX/072-recent-target.txt"
rm -f "$SANDBOX/072-opened.txt"
printf 'kinbench-072 recent items target\n' > "$TARGET"
# Pre-open it so it lands in Recent Items, then close
/usr/bin/open -g "$TARGET" 2>/dev/null
/bin/sleep 1
/usr/bin/osascript -e 'tell application "TextEdit" to close (every document whose name = "072-recent-target.txt") saving no' 2>/dev/null || true
echo "→ planted target + pre-opened so it appears in Recent Items"
