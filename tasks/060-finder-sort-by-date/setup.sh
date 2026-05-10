#!/usr/bin/env bash
set -uo pipefail
SANDBOX="$HOME/Desktop/kinbench"
mkdir -p "$SANDBOX"
mkdir -p "$HOME/.kinbench"
# Stash previous sort key so we can detect a change
PRE="$(/usr/bin/defaults read com.apple.finder FXPreferredGroupBy 2>/dev/null || echo "None")"
echo "$PRE" > "$HOME/.kinbench/060-pre-sort"
# Force a starting sort that's NOT date modified
/usr/bin/defaults write com.apple.finder FXPreferredGroupBy "Name" 2>/dev/null
/usr/bin/killall Finder 2>/dev/null
/bin/sleep 1
# Plant a few files with different mod dates so Date Modified sort is meaningful
/usr/bin/touch -t 202401010000 "$SANDBOX/060-old.txt"
/usr/bin/touch -t 202506010000 "$SANDBOX/060-mid.txt"
/usr/bin/touch                  "$SANDBOX/060-new.txt"
echo "→ pre-sort: $PRE; forced FXPreferredGroupBy=Name; planted 3 files w/ varied mtimes"
