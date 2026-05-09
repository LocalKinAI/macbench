#!/usr/bin/env bash
osascript <<'APPLE' 2>/dev/null || true
tell application "Music"
    repeat with p in (every playlist whose name = "KinBench Mix 339")
        try
            delete p
        end try
    end repeat
end tell
APPLE
