#!/usr/bin/env bash
osascript -e 'tell application "Notes"
    repeat with n in (every note whose name = "KinBench Merge A 185")
        delete n
    end repeat
    repeat with n in (every note whose name = "KinBench Merge B 185")
        delete n
    end repeat
    repeat with n in (every note whose name = "KinBench Merged 185")
        delete n
    end repeat
end tell' 2>/dev/null || true
