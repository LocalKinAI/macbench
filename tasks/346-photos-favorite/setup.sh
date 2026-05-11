#!/usr/bin/env bash
mkdir -p "$HOME/.kinbench"
# Clear favorite flag on the most-recent photo so we can detect a flip.
osascript <<'APPLE' 2>/dev/null || true
tell application "Photos"
    try
        set ms to media items
        if (count of ms) > 0 then
            set last_m to item (count of ms) of ms
            try
                set favorite of last_m to false
            end try
        end if
    end try
end tell
APPLE
# Cache name of most-recent photo for eval.
NAME="$(osascript <<'APPLE' 2>/dev/null
tell application "Photos"
    try
        set ms to media items
        if (count of ms) > 0 then return name of (item (count of ms) of ms)
    end try
    return ""
end tell
APPLE
)"
echo "$NAME" > "$HOME/.kinbench/346-name"
echo "-> tracking photo: $NAME"
