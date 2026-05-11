#!/usr/bin/env bash
set -euo pipefail
mkdir -p "$HOME/Desktop/kinbench"
rm -rf "$HOME/Desktop/kinbench/322-sheet.numbers"
rm -f "$HOME/Desktop/kinbench/322-freeze-confirm.txt"

OUT="$HOME/Desktop/kinbench/322-sheet.numbers"
osascript <<APPLE >/dev/null 2>&1
tell application "Numbers"
    activate
    set d to make new document
    delay 0.6
    try
        tell d
            tell active sheet
                tell first table
                    set value of cell "A1" to "Header A"
                    set value of cell "B1" to "Header B"
                    set value of cell "A2" to "row 2 a"
                    set value of cell "B2" to "row 2 b"
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
echo "→ prepared 322-sheet.numbers"
