#!/usr/bin/env bash
set -uo pipefail
sleep 2
R="$(osascript <<'EOF' 2>/dev/null
tell application "Mail"
    set hasNew to 0
    set hasOld to 0
    repeat with acct in accounts
        try
            set mb to mailbox "kinbench-renamed" of acct
            set hasNew to 1
        end try
        try
            set mb to mailbox "kinbench-rename-src" of acct
            set hasOld to 1
        end try
    end repeat
    try
        set mb to mailbox "kinbench-renamed"
        set hasNew to 1
    end try
    try
        set mb to mailbox "kinbench-rename-src"
        set hasOld to 1
    end try
    return (hasNew as string) & "|" & (hasOld as string)
end tell
EOF
)"
echo "new/old: $R"
NEW="${R%%|*}"
OLD="${R#*|}"
if [[ "${NEW:-0}" -eq 1 ]] && [[ "${OLD:-0}" -eq 0 ]] 2>/dev/null; then
  echo "PASS: renamed"
  exit 0
fi
if [[ "${NEW:-0}" -eq 1 ]] 2>/dev/null; then
  echo "PASS (soft): new mailbox exists but old still around"
  exit 0
fi
echo "FAIL"
exit 1
