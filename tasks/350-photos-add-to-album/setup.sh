#!/usr/bin/env bash
osascript <<'APPLE' 2>/dev/null || true
tell application "Photos"
    repeat with a in (every album whose name = "KinBench Album 350")
        try
            delete a
        end try
    end repeat
    make new album with properties {name:"KinBench Album 350"}
end tell
APPLE
echo "-> album seeded empty"
