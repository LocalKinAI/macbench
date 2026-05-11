#!/usr/bin/env bash
set -euo pipefail
mkdir -p "$HOME/Desktop/kinbench"
rm -rf "$HOME/Desktop/kinbench/320-sheet.numbers"
rm -f "$HOME/Desktop/kinbench/320-filter-confirm.txt"

OUT="$HOME/Desktop/kinbench/320-sheet.numbers"
osascript <<APPLE >/dev/null 2>&1
tell application "Numbers"
    activate
    set d to make new document
    delay 0.6
    try
        tell d
            tell active sheet
                tell first table
                    set value of cell "A1" to 50
                    set value of cell "A2" to 150
                    set value of cell "A3" to 75
                    set value of cell "A4" to 200
                    set value of cell "A5" to 25
                    set value of cell "A6" to 300
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
echo "→ prepared 320-sheet.numbers (mixed values)"
