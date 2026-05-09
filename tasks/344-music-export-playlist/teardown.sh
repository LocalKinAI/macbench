#!/usr/bin/env bash
osascript -e 'tell application "Music"
    repeat with p in (every playlist whose name = "KinBench Mix 344")
        try
            delete p
        end try
    end repeat
end tell' 2>/dev/null || true
