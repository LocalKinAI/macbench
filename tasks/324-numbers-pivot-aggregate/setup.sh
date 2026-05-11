#!/usr/bin/env bash
set -euo pipefail
mkdir -p "$HOME/Desktop/kinbench"
rm -rf "$HOME/Desktop/kinbench/324-sheet.numbers"
rm -f "$HOME/Desktop/kinbench/324-pivot-confirm.txt"

OUT="$HOME/Desktop/kinbench/324-sheet.numbers"
osascript <<APPLE >/dev/null 2>&1
tell application "Numbers"
    activate
    set d to make new document
    delay 0.6
    try
        tell d
            tell active sheet
                tell first table
                    set value of cell "A1" to "Category"
                    set value of cell "B1" to "Amount"
                    set value of cell "A2" to "Food"
                    set value of cell "B2" to 10
                    set value of cell "A3" to "Travel"
                    set value of cell "B3" to 25
                    set value of cell "A4" to "Food"
                    set value of cell "B4" to 15
                    set value of cell "A5" to "Travel"
                    set value of cell "B5" to 5
                    set value of cell "A6" to "Books"
                    set value of cell "B6" to 30
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
echo "→ prepared 324-sheet.numbers (Food=25, Travel=30, Books=30)"
