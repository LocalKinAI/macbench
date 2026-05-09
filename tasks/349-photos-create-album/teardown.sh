#!/usr/bin/env bash
osascript -e 'tell application "Photos"
    repeat with a in (every album whose name = "KinBench Album 349")
        try
            delete a
        end try
    end repeat
end tell' 2>/dev/null || true
