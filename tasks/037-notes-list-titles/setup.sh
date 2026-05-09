#!/usr/bin/env bash
# Plant 3 notes with prefix + clear sandbox file.
set -uo pipefail
mkdir -p "$HOME/Desktop/kinbench"
rm -f "$HOME/Desktop/kinbench/037-titles.txt"

osascript <<'EOF' 2>/dev/null || true
tell application "Notes"
    set toDel to (every note whose name starts with "KinBench Listing")
    repeat with n in toDel
        delete n
    end repeat
    make new note with properties {name:"KinBench Listing Alpha", body:"a"}
    make new note with properties {name:"KinBench Listing Beta", body:"b"}
    make new note with properties {name:"KinBench Listing Gamma", body:"c"}
end tell
EOF
echo "→ planted 3 KinBench Listing notes"
