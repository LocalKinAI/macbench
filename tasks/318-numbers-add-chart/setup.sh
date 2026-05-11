#!/usr/bin/env bash
set -euo pipefail
mkdir -p "$HOME/Desktop/kinbench"
rm -rf "$HOME/Desktop/kinbench/318-sheet.numbers"
rm -f "$HOME/Desktop/kinbench/318-chart-confirm.txt"

OUT="$HOME/Desktop/kinbench/318-sheet.numbers"
osascript <<APPLE >/dev/null 2>&1
tell application "Numbers"
    activate
    set d to make new document
    delay 0.6
    try
        tell d
            tell active sheet
                tell first table
                    set value of cell "A1" to "Label"
                    set value of cell "B1" to "Value"
                    repeat with i from 2 to 10
                        set value of cell ("A" & i) to ("Item" & i)
                        set value of cell ("B" & i) to (i * 7)
                    end repeat
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
echo "→ prepared 318-sheet.numbers with A1:B10 data"
