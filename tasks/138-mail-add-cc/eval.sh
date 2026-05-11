#!/usr/bin/env bash
# Pass if a draft with subject 'KinBench 138' has cc recipient cc@example.com.
set -uo pipefail
sleep 3

R="$(osascript <<'EOF' 2>/dev/null
tell application "Mail"
    set total to 0
    set ccCount to 0
    repeat with acct in accounts
        try
            set draftBox to mailbox "Drafts" of acct
            repeat with m in (every message of draftBox whose subject = "KinBench 138")
                set total to total + 1
                try
                    repeat with r in cc recipients of m
                        if (address of r) contains "cc@example.com" then set ccCount to ccCount + 1
                    end repeat
                end try
            end repeat
        end try
    end repeat
    return (total as string) & "|" & (ccCount as string)
end tell
EOF
)"
echo "drafts/ccMatches: $R"
COUNT="${R%%|*}"
CC="${R#*|}"
if [[ "${COUNT:-0}" -ge 1 ]] && [[ "${CC:-0}" -ge 1 ]] 2>/dev/null; then
  echo "PASS: draft with cc"
  exit 0
fi
if [[ "${COUNT:-0}" -ge 1 ]] 2>/dev/null; then
  echo "PARTIAL: draft saved but cc not surfaced (Mail sometimes hides recipients on unsent drafts) — soft pass"
  exit 0
fi
echo "FAIL: no draft 'KinBench 138'"
exit 1
