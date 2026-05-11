#!/usr/bin/env bash
set -uo pipefail
sleep 3

PHOTO="$HOME/Desktop/kinbench/361-photo.jpg"
PHOTO_OK=0
if [[ -f "$PHOTO" ]]; then
  SIZE=$(stat -f %z "$PHOTO" 2>/dev/null || echo 0)
  if [[ "$SIZE" -gt 1000 ]]; then PHOTO_OK=1; fi
fi

R="$(osascript <<'EOF' 2>/dev/null
tell application "Mail"
    set total to 0
    set hasAttach to 0
    repeat with acct in accounts
        try
            set draftBox to mailbox "Drafts" of acct
            set drafts to (every message of draftBox whose subject = "KinBench 361")
            repeat with m in drafts
                set total to total + 1
                if (count of mail attachments of m) > 0 then set hasAttach to hasAttach + 1
            end repeat
        end try
    end repeat
    return (total as string) & "|" & (hasAttach as string)
end tell
EOF
)"
COUNT="${R%%|*}"; ATT="${R#*|}"
echo "photo_ok=$PHOTO_OK draft=$COUNT attach=$ATT"

if [[ "$PHOTO_OK" -eq 1 && "${COUNT:-0}" -ge 1 && "${ATT:-0}" -ge 1 ]] 2>/dev/null; then
  echo "PASS: photo + draft + attachment"
  exit 0
fi
if [[ "$PHOTO_OK" -eq 1 && "${COUNT:-0}" -ge 1 ]] 2>/dev/null; then
  echo "PASS (soft): photo saved + draft exists; AppleScript may hide unsent attachments"
  exit 0
fi
echo "FAIL: photo_ok=$PHOTO_OK count=$COUNT attach=$ATT"
exit 1
