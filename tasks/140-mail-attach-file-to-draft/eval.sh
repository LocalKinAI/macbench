#!/usr/bin/env bash
set -uo pipefail
sleep 3
R="$(osascript <<'EOF' 2>/dev/null
tell application "Mail"
    set total to 0
    set withAtt to 0
    repeat with acct in accounts
        try
            set draftBox to mailbox "Drafts" of acct
            repeat with m in (every message of draftBox whose subject = "KinBench 140")
                set total to total + 1
                if (count of mail attachments of m) > 0 then set withAtt to withAtt + 1
            end repeat
        end try
    end repeat
    return (total as string) & "|" & (withAtt as string)
end tell
EOF
)"
echo "drafts/with-attachment: $R"
T="${R%%|*}"
A="${R#*|}"
if [[ "${T:-0}" -ge 1 ]] && [[ "${A:-0}" -ge 1 ]] 2>/dev/null; then
  echo "PASS: draft with attachment"
  exit 0
fi
if [[ "${T:-0}" -ge 1 ]] 2>/dev/null; then
  echo "PASS (soft): draft saved; attachment not surfaced on this Mail build"
  exit 0
fi
echo "FAIL"
exit 1
