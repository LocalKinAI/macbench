#!/usr/bin/env bash
set -uo pipefail
sleep 1
B="$(osascript <<'APPLE' 2>/dev/null
tell application "Reminders"
    repeat with lst in lists
        try
            set rs to (every reminder of lst whose name = "KinBench Tag 232")
            repeat with r in rs
                try
                    return body of r
                end try
            end repeat
        end try
    end repeat
    return ""
end tell
APPLE
)"
echo "body: '$B'"
if printf '%s' "$B" | grep -qE '#kinbench\b'; then
  echo "PASS"; exit 0
fi
# Reminders may store hashtags via 'tags' property; try that
T="$(osascript <<'APPLE' 2>/dev/null
tell application "Reminders"
    repeat with lst in lists
        try
            set rs to (every reminder of lst whose name = "KinBench Tag 232")
            repeat with r in rs
                try
                    return (count of (every tag of r)) as string
                end try
            end repeat
        end try
    end repeat
    return "0"
end tell
APPLE
)"
echo "tag count: $T"
[[ "$T" -ge 1 ]] 2>/dev/null && { echo "PASS (tag property)"; exit 0; }
echo "FAIL: no tag"
exit 1
