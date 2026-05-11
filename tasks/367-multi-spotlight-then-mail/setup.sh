#!/usr/bin/env bash
set -uo pipefail
mkdir -p "$HOME/Desktop/kinbench"

# Plant contact (best-effort; AddressBook AS may require permission)
osascript <<'APPLE' 2>/dev/null || true
tell application "Contacts"
    try
        repeat with p in (every person whose name = "KinBench Apple 367")
            delete p
        end repeat
    end try
    try
        set newP to make new person with properties {first name:"KinBench Apple", last name:"367"}
        tell newP
            make new email at end of emails with properties {label:"work", value:"kinbench-apple@example.com"}
        end tell
        save
    end try
end tell
APPLE

# Clear prior draft
osascript <<'APPLE' 2>/dev/null || true
tell application "Mail"
    repeat with acct in accounts
        try
            set draftBox to mailbox "Drafts" of acct
            repeat with m in (every message of draftBox whose subject = "KinBench 367")
                delete m
            end repeat
        end try
    end repeat
end tell
APPLE
echo "→ contact planted + drafts cleared"
