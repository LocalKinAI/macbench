#!/usr/bin/env bash
osascript <<'APPLE' 2>/dev/null || true
tell application "Music"
    repeat with p in (every user playlist whose name = "KinBench Mix 340")
        try
            delete p
        end try
    end repeat
    make new user playlist with properties {name:"KinBench Mix 340"}
end tell
APPLE
echo "-> playlist 'KinBench Mix 340' created empty"
