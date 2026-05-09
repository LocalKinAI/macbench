#!/usr/bin/env bash
mkdir -p "$HOME/Desktop/kinbench"
rm -f "$HOME/Desktop/kinbench/344-tracks.txt"
osascript <<'APPLE' 2>/dev/null || true
tell application "Music"
    repeat with p in (every playlist whose name = "KinBench Mix 344")
        try
            delete p
        end try
    end repeat
    -- Plant a playlist with at least 1 track if any exist in library
    if (count of (every track of library playlist 1)) > 0 then
        set newPL to make new user playlist with properties {name:"KinBench Mix 344"}
        try
            duplicate (track 1 of library playlist 1) to newPL
        end try
    end if
end tell
APPLE
echo "→ ready"
