#!/usr/bin/env bash
osascript <<'APPLE' 2>/dev/null || true
tell application "Notes"
    repeat with n in (every note whose name = "KinBench Clipboard 363")
        delete n
    end repeat
end tell
APPLE
osascript -e 'tell application "Safari" to quit' 2>/dev/null || true
sleep 1
echo "→ note 363 cleared, Safari quit"
