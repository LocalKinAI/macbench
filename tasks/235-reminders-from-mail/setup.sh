#!/usr/bin/env bash
# 235-reminders-from-mail setup
#
# Plants a Mail-message-style text file with three action items, and
# creates the destination Reminders list (clearing prior items first).
set -uo pipefail

SANDBOX="$HOME/Desktop/kinbench"
mkdir -p "$SANDBOX"
FIXTURE="$SANDBOX/235-mail.txt"

/bin/cat > "$FIXTURE" <<'EOF'
From: alice@example.com
To: jacky@example.com
Subject: Three things before Friday
Date: Mon, 10 May 2026 09:00:00

Hi Jacky,

A few action items from our standup — could you handle these by EOW?

Please review the Q3 budget draft and flag anything that looks off.
Please book the offsite venue for the engineering team.
Please send the launch checklist to the marketing list.

Thanks,
Alice
EOF
echo "→ wrote fixture: $FIXTURE"

/usr/bin/osascript <<'APPLE' 2>/dev/null || true
tell application "Reminders"
    try
        delete (first list whose name = "kinbench-from-mail-235")
    end try
    make new list with properties {name:"kinbench-from-mail-235"}
end tell
APPLE
echo "→ list 'kinbench-from-mail-235' ready"
