#!/usr/bin/env bash
set -uo pipefail
mkdir -p "$HOME/Desktop/kinbench"
rm -f "$HOME/Desktop/kinbench/181-tagged-titles.txt"

osascript <<'APPLE' 2>/dev/null || true
tell application "Notes"
    repeat with title in {"KinBench Tag181 alpha", "KinBench Tag181 bravo", "KinBench Tag181 charlie"}
        repeat with n in (every note whose name = title)
            delete n
        end repeat
    end repeat
    make new note with properties {name:"KinBench Tag181 alpha", body:"alpha body #kinbench-181"}
    make new note with properties {name:"KinBench Tag181 bravo", body:"bravo body — not tagged"}
    make new note with properties {name:"KinBench Tag181 charlie", body:"charlie body #kinbench-181 here"}
end tell
APPLE
echo "→ 3 source notes ready (alpha + charlie tagged, bravo not)"
