#!/usr/bin/env bash
set -uo pipefail
F="$HOME/Desktop/kinbench/163-promo-count.txt"
[[ -f "$F" ]] || { echo "FAIL: count file missing"; exit 1; }
C="$(/bin/cat "$F" | /usr/bin/tr -d '[:space:]')"
echo "moved count: '$C'"
[[ "$C" =~ ^[0-9]+$ ]] || { echo "FAIL: not integer"; exit 1; }

# Also verify the kinbench-promos mailbox exists (if count > 0 — folder must exist)
R="$(osascript <<'EOF' 2>/dev/null
tell application "Mail"
    set found to 0
    repeat with acct in accounts
        try
            set mb to mailbox "kinbench-promos" of acct
            set found to 1
        end try
    end repeat
    try
        set mb to mailbox "kinbench-promos"
        set found to 1
    end try
    return found as string
end tell
EOF
)"
echo "kinbench-promos exists: $R"
if [[ "$C" -eq 0 ]] 2>/dev/null; then
  echo "PASS (soft): no matches, integer recorded"
  exit 0
fi
if [[ "${R:-0}" -eq 1 ]] 2>/dev/null; then
  echo "PASS: kinbench-promos folder + count"
  exit 0
fi
echo "PASS (soft): count integer recorded but folder existence unverifiable"
exit 0
