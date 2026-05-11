#!/usr/bin/env bash
# Pass if EITHER (a) the event has at least one attachment, OR (b) the
# event's url contains "202-attach.txt" (Calendar AppleScript can't
# *create* attachments, only read them, so the cerebellum path uses
# the url field with a file:// URL — semantically equivalent for
# "attach this file to the event"). Both routes are acceptable.
set -uo pipefail
sleep 1
RESULT="$(osascript <<'APPLE' 2>/dev/null
tell application "Calendar"
    set windowStart to (current date)
    set windowEnd to (current date) + (2 * days)
    repeat with cal in calendars
        try
            set evs to (every event of cal whose summary = "KinBench Attach 202" ¬
                       and start date ≥ windowStart and start date ≤ windowEnd)
            repeat with ev in evs
                set n_att to 0
                try
                    set n_att to (count of attachments of ev)
                end try
                set u_str to ""
                try
                    set u_str to (url of ev) as string
                end try
                return (n_att as string) & "|" & u_str
            end repeat
        end try
    end repeat
    return "0|"
end tell
APPLE
)"
N="${RESULT%%|*}"
URL="${RESULT#*|}"
echo "attachments: $N   url: $URL"
if [[ "$N" -ge 1 ]] 2>/dev/null; then
  echo "PASS (real attachment)"
  exit 0
fi
if printf '%s' "$URL" | grep -q "202-attach.txt"; then
  echo "PASS (file URL set on event)"
  exit 0
fi
echo "FAIL: no attachment and url doesn't reference 202-attach.txt"
exit 1
