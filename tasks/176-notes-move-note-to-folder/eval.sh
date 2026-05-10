#!/usr/bin/env bash
set -uo pipefail
sleep 1
# Directly check whether the target note exists inside kinbench-folder
# (more robust than reading container of item 1, which depends on iteration order
# when multiple matches exist across folders).
N="$(osascript <<'APPLE' 2>/dev/null
tell application "Notes"
    set total to 0
    repeat with acct in accounts
        try
            repeat with f in folders of acct
                if name of f is "kinbench-folder" then
                    set total to total + (count of (every note of f whose name = "KinBench Move 176"))
                end if
            end repeat
        end try
    end repeat
    return total as string
end tell
APPLE
)"
echo "matches in kinbench-folder: '$N'"
[[ "${N:-0}" -ge 1 ]] 2>/dev/null && { echo "PASS: note is inside kinbench-folder"; exit 0; }
echo "FAIL: note not found in kinbench-folder"
exit 1
