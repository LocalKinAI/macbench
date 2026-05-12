#!/usr/bin/env bash
set -uo pipefail
mkdir -p "$HOME/Desktop/kinbench"
rm -f "$HOME/Desktop/kinbench/389-h1.txt"
# Wipe any prior KinBench Web 389 note
osascript <<'APPLE' 2>/dev/null || true
tell application "Notes"
    repeat with acct in accounts
        repeat with f in folders of acct
            try
                repeat with n in (every note of f whose name is "KinBench Web 389")
                    delete n
                end repeat
            end try
        end repeat
    end repeat
end tell
APPLE
