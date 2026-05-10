#!/usr/bin/env bash
set -uo pipefail
mkdir -p "$HOME/Desktop/kinbench"
rm -f "$HOME/Desktop/kinbench/186-export.pdf"

osascript <<'APPLE' 2>/dev/null || true
tell application "Notes"
    repeat with title in {"KinBench Search 186 distractor 1", "KinBench Search 186 distractor 2", "KinBench Search 186 distractor 3", "KinBench Search 186 target"}
        repeat with n in (every note whose name = title)
            delete n
        end repeat
    end repeat
    make new note with properties {name:"KinBench Search 186 distractor 1", body:"plain content, no marker"}
    make new note with properties {name:"KinBench Search 186 distractor 2", body:"more content, still no marker"}
    make new note with properties {name:"KinBench Search 186 distractor 3", body:"distractor talks about ananas but not pineapple"}
    make new note with properties {name:"KinBench Search 186 target", body:"this is the target note PINEAPPLE-MARKER-186 search hit"}
end tell
APPLE
echo "→ 4 notes seeded; only target has PINEAPPLE-MARKER-186"
