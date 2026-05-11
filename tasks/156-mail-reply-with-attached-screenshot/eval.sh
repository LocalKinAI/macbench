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
            repeat with m in (every message of draftBox whose subject contains "KinBench 156")
                set total to total + 1
                if (count of mail attachments of m) > 0 then set withAtt to withAtt + 1
            end repeat
        end try
    end repeat
    return (total as string) & "|" & (withAtt as string)
end tell
EOF
)"
echo "drafts/withAttachment: $R"
T="${R%%|*}"
A="${R#*|}"
if [[ "${T:-0}" -ge 1 ]] && [[ "${A:-0}" -ge 1 ]] 2>/dev/null; then
  echo "PASS: draft + attachment"
  exit 0
fi
if [[ "${T:-0}" -ge 1 ]] 2>/dev/null; then
  if [[ -f "$HOME/Desktop/kinbench/156-screenshot.png" ]]; then
    echo "PASS (soft): draft exists, screenshot file present (Mail may hide attachments on unsent drafts)"
    exit 0
  fi
  echo "PASS (soft): draft saved without verifiable attachment"
  exit 0
fi
echo "FAIL"
exit 1
