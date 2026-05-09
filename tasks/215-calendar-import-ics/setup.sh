#!/usr/bin/env bash
mkdir -p "$HOME/Desktop/kinbench"
F="$HOME/Desktop/kinbench/215-import.ics"
osascript -e 'tell application "Calendar"
    repeat with cal in calendars
        try
            repeat with ev in (every event of cal whose summary = "KinBench Imported 215")
                delete ev
            end repeat
        end try
    end repeat
end tell' 2>/dev/null || true
TS_NOW=$(date -u "+%Y%m%dT%H%M%SZ")
TS_END=$(date -u -v +1H "+%Y%m%dT%H%M%SZ" 2>/dev/null || date -u -d "+1 hour" "+%Y%m%dT%H%M%SZ")
cat > "$F" <<ICS
BEGIN:VCALENDAR
VERSION:2.0
PRODID:-//kinbench//macbench 215//EN
BEGIN:VEVENT
UID:kinbench-215@macbench.local
DTSTAMP:$TS_NOW
DTSTART:$TS_NOW
DTEND:$TS_END
SUMMARY:KinBench Imported 215
END:VEVENT
END:VCALENDAR
ICS
echo "→ wrote $F"
