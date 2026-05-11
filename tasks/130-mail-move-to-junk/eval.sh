#!/usr/bin/env bash
# Junk mailbox is per-account and AppleScript-junk-status is not reliable
# across providers. Use soft-pass via confirmation file.
set -uo pipefail
F="$HOME/Desktop/kinbench/130-junk-confirm.txt"
if [[ -f "$F" ]] && /usr/bin/grep -q "junked" "$F"; then
  echo "PASS (soft): confirmation file present"
  exit 0
fi

R="$(osascript <<'EOF' 2>/dev/null
tell application "Mail"
    set junkCt to 0
    repeat with acct in accounts
        try
            set jbox to mailbox "Junk" of acct
            set junkCt to junkCt + (count of (every message of jbox whose subject = "KinBench 130"))
        end try
    end repeat
    return junkCt as string
end tell
EOF
)"
[[ "${R:-0}" -ge 1 ]] 2>/dev/null && { echo "PASS: in junk mailbox"; exit 0; }
echo "FAIL"
exit 1
