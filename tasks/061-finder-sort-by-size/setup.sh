#!/usr/bin/env bash
set -uo pipefail
SANDBOX="$HOME/Desktop/kinbench"
mkdir -p "$SANDBOX"
mkdir -p "$HOME/.kinbench"
PRE="$(/usr/bin/defaults read com.apple.finder FXPreferredGroupBy 2>/dev/null || echo "None")"
echo "$PRE" > "$HOME/.kinbench/061-pre-sort"
# Force a starting sort that's NOT size
/usr/bin/defaults write com.apple.finder FXPreferredGroupBy "Name" 2>/dev/null
/usr/bin/killall Finder 2>/dev/null
/bin/sleep 1
# Plant 3 files of clearly different sizes so size-sort is meaningful
/bin/dd if=/dev/zero of="$SANDBOX/061-tiny.bin" bs=1 count=10 2>/dev/null
/bin/dd if=/dev/zero of="$SANDBOX/061-medium.bin" bs=1024 count=10 2>/dev/null
/bin/dd if=/dev/zero of="$SANDBOX/061-large.bin" bs=1024 count=1000 2>/dev/null
echo "→ pre-sort: $PRE; forced FXPreferredGroupBy=Name; planted 3 files w/ varied sizes"
