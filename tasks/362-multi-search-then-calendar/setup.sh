#!/usr/bin/env bash
set -uo pipefail
mkdir -p "$HOME/Desktop/kinbench"

# Plant a Mail draft with the flight info
osascript <<'APPLE' 2>/dev/null || true
tell application "Mail"
    repeat with acct in accounts
        try
            set draftBox to mailbox "Drafts" of acct
            repeat with m in (every message of draftBox whose subject = "Flight KinBench 362")
                delete m
            end repeat
        end try
    end repeat
    set m to make new outgoing message with properties {subject:"Flight KinBench 362", content:"Departure: 2026-06-15 14:30 from SFO. Arrival JFK 22:50. Confirmation: KB362"}
    save m
    try
        tell window 1 to close saving yes
    end try
end tell
APPLE
sleep 1

# Clear prior event
osascript <<'APPLE' 2>/dev/null || true
tell application "Calendar"
    repeat with cal in calendars
        try
            repeat with ev in (every event of cal whose summary = "KinBench Flight 362")
                delete ev
            end repeat
        end try
    end repeat
end tell
APPLE
echo "→ planted Flight draft + cleared prior calendar event"
