#!/usr/bin/env bash
# NOTE: AppleScript `set pinned of newNote to true` silently fails on
# iCloud Notes in macOS 14+, so we can't programmatically pin during setup.
# Agent's task is "unpin" — eval is soft-pass on "note touched, not deleted".
osascript <<'APPLE' 2>/dev/null || true
tell application "Notes"
    repeat with n in (every note whose name = "KinBench Unpin 165")
        delete n
    end repeat
    make new note with properties {name:"KinBench Unpin 165", body:"this note may or may not start pinned (Notes pinning isn't AppleScript-settable on macOS 14+)"}
end tell
APPLE
