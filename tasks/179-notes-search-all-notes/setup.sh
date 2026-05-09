#!/usr/bin/env bash
mkdir -p "$HOME/Desktop/kinbench"
rm -f "$HOME/Desktop/kinbench/179-count.txt"
osascript <<'APPLE' 2>/dev/null || true
tell application "Notes"
    -- ensure 3 matching, planted notes
    repeat with n in (every note whose name starts with "KinBench Search 179")
        delete n
    end repeat
    make new note with properties {name:"KinBench Search 179 A", body:"contains kinbench-search-179 token"}
    make new note with properties {name:"KinBench Search 179 B", body:"another with kinbench-search-179 mention"}
    make new note with properties {name:"KinBench Search 179 C", body:"kinbench-search-179 again"}
    -- 1 distractor without the term
    repeat with n in (every note whose name = "KinBench Search 179 Distractor")
        delete n
    end repeat
    make new note with properties {name:"KinBench Search 179 Distractor", body:"not relevant"}
end tell
APPLE
echo "→ 3 matching + 1 distractor planted"
