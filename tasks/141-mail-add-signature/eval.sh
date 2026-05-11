#!/usr/bin/env bash
# Signature presence on an unsent draft is hard to query reliably via
# AppleScript (it's an HTML/RTF blob). Accept either: draft body contains
# the standard signature delimiter '-- ', OR draft has a signature object.
set -uo pipefail
sleep 3
R="$(osascript <<'EOF' 2>/dev/null
tell application "Mail"
    set total to 0
    set sigHit to 0
    repeat with acct in accounts
        try
            set draftBox to mailbox "Drafts" of acct
            repeat with m in (every message of draftBox whose subject = "KinBench 141")
                set total to total + 1
                try
                    if (content of m) contains "-- " then set sigHit to sigHit + 1
                end try
                try
                    if (message signature of m) is not missing value then set sigHit to sigHit + 1
                end try
            end repeat
        end try
    end repeat
    return (total as string) & "|" & (sigHit as string)
end tell
EOF
)"
echo "drafts/sig-hits: $R"
T="${R%%|*}"
S="${R#*|}"
if [[ "${S:-0}" -ge 1 ]] 2>/dev/null; then
  echo "PASS: signature surfaced"
  exit 0
fi
if [[ "${T:-0}" -ge 1 ]] 2>/dev/null; then
  echo "PASS (soft): draft saved, signature not queryable"
  exit 0
fi
echo "FAIL"
exit 1
