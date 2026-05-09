#!/usr/bin/env bash
osascript -e 'tell application "Notes"
    repeat with n in (every note whose name starts with "KinBench Search 179")
        delete n
    end repeat
end tell' 2>/dev/null || true
