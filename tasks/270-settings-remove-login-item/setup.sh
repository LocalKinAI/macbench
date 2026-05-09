#!/usr/bin/env bash
osascript -e 'tell application "System Events"
    if not (exists login item "TextEdit") then
        make new login item at end with properties {name:"TextEdit", path:"/System/Applications/TextEdit.app", hidden:false}
    end if
end tell' 2>/dev/null || true
echo "→ ensured TextEdit in login items"
