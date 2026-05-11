#!/usr/bin/env bash
# Wipe any matching draft so we can detect a new one.
osascript <<'APPLE' 2>/dev/null || true
tell application "Mail"
    repeat with acct in accounts
        try
            set draftBox to mailbox "Drafts" of acct
            repeat with m in (every message of draftBox whose subject starts with "Apple Park")
                delete m
            end repeat
        end try
    end repeat
end tell
APPLE
echo "-> drafts cleared"
