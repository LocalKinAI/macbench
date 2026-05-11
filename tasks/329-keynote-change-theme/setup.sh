#!/usr/bin/env bash
set -euo pipefail
mkdir -p "$HOME/Desktop/kinbench"
rm -rf "$HOME/Desktop/kinbench/329-deck.key"
rm -f "$HOME/Desktop/kinbench/329-theme-confirm.txt"

OUT="$HOME/Desktop/kinbench/329-deck.key"
osascript <<APPLE >/dev/null 2>&1
tell application "Keynote"
    activate
    set d to make new document
    delay 0.6
    try
        save d in (POSIX file "$OUT")
    end try
    delay 0.5
    try
        close d saving yes
    end try
end tell
APPLE
sleep 0.5
open -a Keynote "$OUT" 2>/dev/null || true
echo "→ prepared 329-deck.key"
