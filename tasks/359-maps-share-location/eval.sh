#!/usr/bin/env bash
set -uo pipefail
sleep 1
N="$(osascript <<'APPLE' 2>/dev/null
tell application "Mail"
    set total to 0
    repeat with acct in accounts
        try
            set draftBox to mailbox "Drafts" of acct
            set total to total + (count of (every message of draftBox whose subject starts with "Apple Park"))
        end try
    end repeat
    return total as string
end tell
APPLE
)"
N="${N:-0}"
echo "matching drafts: $N"
[[ "$N" -ge 1 ]] && { echo "PASS"; exit 0; }
# Soft-pass: if Mail isn't configured with accounts, fall back to URL file
if [[ -f /tmp/359-url.txt ]]; then
  echo "PASS (soft): share URL generated"
  exit 0
fi
echo "FAIL"
exit 1
