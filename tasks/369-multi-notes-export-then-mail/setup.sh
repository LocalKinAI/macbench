#!/usr/bin/env bash
set -uo pipefail
mkdir -p "$HOME/Desktop/kinbench"
rm -f "$HOME/Desktop/kinbench/369-note.pdf"

osascript <<'APPLE' 2>/dev/null || true
tell application "Notes"
    repeat with n in (every note whose name = "KinBench Export 369")
        delete n
    end repeat
    make new note with properties {name:"KinBench Export 369", body:"This note will be exported as PDF and attached to a Mail draft. KINBENCH-EXPORT-MARKER-369"}
end tell
APPLE

osascript <<'APPLE' 2>/dev/null || true
tell application "Mail"
    repeat with acct in accounts
        try
            set draftBox to mailbox "Drafts" of acct
            repeat with m in (every message of draftBox whose subject = "KinBench 369")
                delete m
            end repeat
        end try
    end repeat
end tell
APPLE
echo "→ note + clean drafts ready"
