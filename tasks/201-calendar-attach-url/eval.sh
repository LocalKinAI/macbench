#!/usr/bin/env bash
set -uo pipefail
sleep 1
URL="$(osascript <<'APPLE' 2>/dev/null
tell application "Calendar"
    repeat with cal in calendars
        try
            repeat with ev in (every event of cal whose summary = "KinBench URL 201")
                try
                    return url of ev
                end try
            end repeat
        end try
    end repeat
    return ""
end tell
APPLE
)"
echo "url: '$URL'"
case "$URL" in
  *localkin*|*://*) echo "PASS: URL set"; exit 0 ;;
  *) echo "FAIL: no URL on event"; exit 1 ;;
esac
