#!/usr/bin/env bash
set -euo pipefail
mkdir -p "$HOME/Desktop/kinbench"
rm -rf "$HOME/Desktop/kinbench/325-sheet.numbers"
rm -f "$HOME/Desktop/kinbench/325-sheet.pdf"

OUT="$HOME/Desktop/kinbench/325-sheet.numbers"
osascript <<APPLE >/dev/null 2>&1
tell application "Numbers"
    activate
    set d to make new document
    delay 0.6
    try
        tell d
            tell active sheet
                tell first table
                    set value of cell "A1" to "KinBench 325"
                    set value of cell "A2" to 1
                    set value of cell "A3" to 2
                    set value of cell "A4" to 3
                end tell
            end tell
        end tell
    end try
    delay 0.3
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
open -a Numbers "$OUT" 2>/dev/null || true
echo "→ prepared 325-sheet.numbers"
