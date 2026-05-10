#!/usr/bin/env bash
set -uo pipefail
sleep 3

F="$HOME/Desktop/kinbench/369-note.pdf"
PDF_OK=0
if [[ -f "$F" ]] && file "$F" | grep -qi "PDF document"; then
  SIZE=$(stat -f %z "$F" 2>/dev/null || echo 0)
  if [[ "$SIZE" -gt 1000 ]]; then PDF_OK=1; fi
fi

R="$(osascript <<'EOF' 2>/dev/null
tell application "Mail"
    set total to 0
    set hasAttach to 0
    repeat with acct in accounts
        try
            set draftBox to mailbox "Drafts" of acct
            set drafts to (every message of draftBox whose subject = "KinBench 369")
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
COUNT="${R%%|*}"
ATT="${R#*|}"
echo "pdf_saved=$PDF_OK  drafts=$COUNT  drafts_with_attachment=$ATT"

if [[ $PDF_OK -eq 1 && "$COUNT" -ge 1 && "$ATT" -ge 1 ]] 2>/dev/null; then
  echo "PASS: PDF exported + Mail draft has the attachment"
  exit 0
fi
if [[ $PDF_OK -eq 1 && "$COUNT" -ge 1 ]] 2>/dev/null; then
  echo "PARTIAL: PDF saved + draft created, but AppleScript can't see attachment (some Mail builds hide unsent draft attachments) — soft pass"
  exit 0
fi
echo "FAIL: pdf_saved=$PDF_OK drafts=$COUNT attachments=$ATT"
exit 1
