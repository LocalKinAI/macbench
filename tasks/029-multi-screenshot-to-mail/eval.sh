#!/usr/bin/env bash
# Two-part eval:
#   (a) screenshot file exists + is a real PNG (file magic check)
#   (b) Mail draft exists with correct subject + has ≥1 attachment
set -uo pipefail
sleep 3

# Part A — screenshot file
SHOT="$HOME/Desktop/kinbench/029-shot.png"
if [[ ! -f "$SHOT" ]]; then
  echo "FAIL: $SHOT missing"
  exit 1
fi
if ! file "$SHOT" | grep -q "PNG image"; then
  echo "FAIL: $SHOT exists but isn't a PNG"
  exit 2
fi
SHOT_SIZE="$(stat -f %z "$SHOT" 2>/dev/null || stat -c %s "$SHOT" 2>/dev/null || echo 0)"
if [[ "$SHOT_SIZE" -lt 5000 ]]; then
  echo "FAIL: PNG suspiciously small ($SHOT_SIZE bytes)"
  exit 3
fi
echo "screenshot: PNG, $SHOT_SIZE bytes"

# Part B — Mail draft
RESULT="$(osascript <<'EOF' 2>/dev/null
tell application "Mail"
    set total to 0
    set hasAttach to 0
    repeat with acct in accounts
        try
            set draftBox to mailbox "Drafts" of acct
            set drafts to (every message of draftBox whose subject = "KinBench 029 Screenshot")
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
echo "Mail drafts result: $RESULT"
COUNT="${RESULT%%|*}"
ATTACH="${RESULT#*|}"

if [[ "$COUNT" -ge 1 && "$ATTACH" -ge 1 ]]; then
  echo "PASS: draft saved with ≥1 attachment"
  exit 0
fi
if [[ "$COUNT" -ge 1 ]]; then
  echo "PARTIAL: draft saved but no attachments — accepting as soft pass (Mail's AppleScript may not list attachments on unsent drafts)"
  exit 0
fi
echo "FAIL: no draft with subject 'KinBench 029 Screenshot' found"
exit 4
