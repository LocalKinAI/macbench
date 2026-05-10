#!/usr/bin/env bash
osascript <<'APPLE' 2>/dev/null || true
tell application "Notes"
    repeat with n in (every note whose name = "KinBench Source 177")
        delete n
    end repeat
    repeat with n in (every note whose name = "KinBench Target 177")
        delete n
    end repeat
    make new note with properties {name:"KinBench Target 177", body:"Target note. Link should land here."}
    make new note with properties {name:"KinBench Source 177", body:"Source note. Add a link to the target below this line."}
end tell
APPLE
