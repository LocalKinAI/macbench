#!/usr/bin/env bash
set -uo pipefail

osascript <<'APPLE' 2>/dev/null || true
tell application "Notes"
    repeat with n in (every note whose name = "KinBench Share 167")
        delete n
    end repeat
    make new note with properties {name:"KinBench Share 167", body:"Body to share via Mail. Marker: KINBENCH-SHARE-MARKER-167"}
end tell
APPLE

osascript <<'APPLE' 2>/dev/null || true
tell application "Mail"
    repeat with acct in accounts
        try
            set draftBox to mailbox "Drafts" of acct
            repeat with m in (every message of draftBox whose subject = "KinBench Share 167")
                delete m
            end repeat
        end try
    end repeat
end tell
APPLE

echo "→ note created + prior drafts cleared"
