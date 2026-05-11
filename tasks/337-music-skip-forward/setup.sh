#!/usr/bin/env bash
mkdir -p "$HOME/.kinbench"
osascript <<'APPLE' 2>/dev/null || true
tell application "Music"
    try
        if (count of (every track of library playlist 1)) > 0 then
            play (track 1 of library playlist 1)
        end if
    end try
end tell
APPLE
sleep 0.8
PRE="$(osascript -e 'tell application "Music" to try
    return name of current track
on error
    return ""
end try' 2>/dev/null)"
echo "$PRE" > "$HOME/.kinbench/337-pre"
echo "-> pre track: $PRE"
