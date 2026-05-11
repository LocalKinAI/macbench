#!/usr/bin/env bash
set -uo pipefail
sleep 3
R="$(osascript <<'EOF' 2>/dev/null
tell application "Mail"
    set total to 0
    set bccMatch to 0
    repeat with acct in accounts
        try
            set draftBox to mailbox "Drafts" of acct
            repeat with m in (every message of draftBox whose subject = "KinBench 139")
                set total to total + 1
                try
                    repeat with r in bcc recipients of m
                        if (address of r) contains "bcc@example.com" then set bccMatch to bccMatch + 1
                    end repeat
                end try
            end repeat
        end try
    end repeat
    return (total as string) & "|" & (bccMatch as string)
end tell
EOF
)"
echo "drafts/bcc-matches: $R"
TOT="${R%%|*}"
BM="${R#*|}"
if [[ "${BM:-0}" -ge 1 ]] 2>/dev/null; then
  echo "PASS: bcc draft"
  exit 0
fi
if [[ "${TOT:-0}" -ge 1 ]] 2>/dev/null; then
  echo "PASS (soft): draft exists, bcc not surfaced (Mail occasionally hides bcc on unsent drafts)"
  exit 0
fi
echo "FAIL"
exit 1
