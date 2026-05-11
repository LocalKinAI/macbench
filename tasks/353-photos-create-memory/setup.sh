#!/usr/bin/env bash
mkdir -p "$HOME/Desktop/kinbench"
rm -f "$HOME/Desktop/kinbench/353-confirm.txt"
osascript <<'APPLE' 2>/dev/null || true
tell application "Photos"
    repeat with a in (every album whose name = "KinBench Album 353")
        try
            delete a
        end try
    end repeat
    set newA to make new album with properties {name:"KinBench Album 353"}
    try
        set ms to media items
        if (count of ms) >= 1 then
            add (items 1 thru 1 of ms) to newA
        end if
    end try
end tell
APPLE
echo "-> album seeded"
