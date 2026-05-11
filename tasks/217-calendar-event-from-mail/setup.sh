#!/usr/bin/env bash
# 217-calendar-event-from-mail setup
# Clean prior calendar event AND prior draft. Plant a Mail draft
# in Drafts mailbox with subject 'KinBench Flight 217' and body
# containing a known departure datetime.
set -uo pipefail
SANDBOX="$HOME/Desktop/kinbench"
mkdir -p "$SANDBOX"

# Depart datetime: 5 days from now at 09:30
DEPART="$(date -v+5d +%Y-%m-%d 2>/dev/null || date -d '+5 days' +%Y-%m-%d) 09:30"
echo "$DEPART" > "$SANDBOX/217-depart.txt"
echo "→ depart=$DEPART (also written to $SANDBOX/217-depart.txt)"

DEPART_ESC="$DEPART"

# Wipe prior calendar event
osascript <<'APPLE' 2>/dev/null || true
tell application "Calendar"
    repeat with cal in calendars
        try
            repeat with ev in (every event of cal whose summary = "KinBench Flight 217")
                delete ev
            end repeat
        end try
    end repeat
end tell
APPLE

# Create Mail draft
osascript <<APPLE 2>/dev/null || true
tell application "Mail"
    activate
    -- delete prior drafts with the same subject
    try
        repeat with acct in accounts
            try
                repeat with mb in mailboxes of acct
                    try
                        if name of mb contains "Draft" then
                            repeat with msg in (every message of mb whose subject = "KinBench Flight 217")
                                delete msg
                            end repeat
                        end if
                    end try
                end repeat
            end try
        end repeat
    end try
    set newDraft to make new outgoing message with properties {subject:"KinBench Flight 217", content:"Your flight departs at $DEPART_ESC. Please arrive 1h early.", visible:false}
    save newDraft
end tell
APPLE
sleep 1
echo "→ planted Mail draft 'KinBench Flight 217' with depart=$DEPART"
