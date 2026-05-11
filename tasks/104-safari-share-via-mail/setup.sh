#!/usr/bin/env bash
set -uo pipefail
osascript -e 'tell application "Safari" to quit' 2>/dev/null || true
sleep 1
# Delete any old KinBench Share drafts so eval is deterministic.
osascript <<'APPLE' 2>/dev/null || true
tell application "Mail"
    try
        repeat with acct in accounts
            try
                set draftBox to mailbox "Drafts" of acct
                repeat with m in (every message of draftBox whose subject starts with "KinBench Share 104")
                    delete m
                end repeat
            end try
        end repeat
    end try
end tell
APPLE
osascript <<'APPLE' 2>/dev/null
tell application "Safari"
    activate
    delay 0.4
    open location "https://www.apple.com"
end tell
APPLE
sleep 2
echo "→ Safari open on apple.com; old share drafts cleared"
