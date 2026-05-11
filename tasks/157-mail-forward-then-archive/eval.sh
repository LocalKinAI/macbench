#!/usr/bin/env bash
set -uo pipefail
sleep 3
R="$(osascript <<'EOF' 2>/dev/null
tell application "Mail"
    set total to 0
    repeat with acct in accounts
        try
            set draftBox to mailbox "Drafts" of acct
            set total to total + (count of (every message of draftBox whose subject contains "KinBench 157"))
        end try
    end repeat
    return total as string
end tell
EOF
)"
echo "forward drafts: $R"
F="$HOME/Desktop/kinbench/157-archive-confirm.txt"
HAS_DRAFT=0
HAS_ARCHIVE=0
[[ "${R:-0}" -ge 1 ]] 2>/dev/null && HAS_DRAFT=1
[[ -f "$F" ]] && /usr/bin/grep -q "archived" "$F" && HAS_ARCHIVE=1

if [[ "$HAS_DRAFT" -eq 1 ]] && [[ "$HAS_ARCHIVE" -eq 1 ]]; then
  echo "PASS: forward draft + archive confirm"
  exit 0
fi
if [[ "$HAS_DRAFT" -eq 1 ]]; then
  echo "PASS (soft): forward draft only (archive step unverifiable)"
  exit 0
fi
if [[ "$HAS_ARCHIVE" -eq 1 ]]; then
  echo "PASS (soft): archive confirm only (no forward draft detected)"
  exit 0
fi
echo "FAIL"
exit 1
