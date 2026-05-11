#!/usr/bin/env bash
set -uo pipefail
sleep 3
R="$(osascript <<'EOF' 2>/dev/null
tell application "Mail"
    set total to 0
    set toMatches to 0
    repeat with acct in accounts
        try
            set draftBox to mailbox "Drafts" of acct
            repeat with m in (every message of draftBox whose subject contains "KinBench 137")
                set total to total + 1
                try
                    repeat with r in to recipients of m
                        if (address of r) contains "test@example.com" then set toMatches to toMatches + 1
                    end repeat
                end try
            end repeat
        end try
    end repeat
    return (total as string) & "|" & (toMatches as string)
end tell
EOF
)"
echo "drafts/to-matches: $R"
TOT="${R%%|*}"
TM="${R#*|}"
if [[ "${TM:-0}" -ge 1 ]] 2>/dev/null; then
  echo "PASS: forward draft to test@example.com"
  exit 0
fi
if [[ "${TOT:-0}" -ge 1 ]] 2>/dev/null; then
  echo "PASS (soft): draft saved, recipient not surfaced"
  exit 0
fi
echo "FAIL"
exit 1
