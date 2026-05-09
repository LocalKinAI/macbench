#!/usr/bin/env bash
osascript <<'APPLE' 2>/dev/null || true
tell application "Notes"
    repeat with n in (every note whose name starts with "KinBench Archive Test")
        delete n
    end repeat
    -- 3 with the kinbench-archive tag in body
    make new note with properties {name:"KinBench Archive Test A", body:"#kinbench-archive content A"}
    make new note with properties {name:"KinBench Archive Test B", body:"#kinbench-archive content B"}
    make new note with properties {name:"KinBench Archive Test C", body:"#kinbench-archive content C"}
end tell
APPLE
echo "→ 3 #kinbench-archive notes planted"
