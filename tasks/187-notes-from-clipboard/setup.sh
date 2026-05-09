#!/usr/bin/env bash
SENTINEL="kinbench-clipboard-sentinel-$$"
echo -n "$SENTINEL" | pbcopy
mkdir -p "$HOME/.kinbench"
echo "$SENTINEL" > "$HOME/.kinbench/187-sentinel"
osascript <<'APPLE' 2>/dev/null || true
tell application "Notes"
    repeat with n in (every note whose name = "KinBench Clipboard 187")
        delete n
    end repeat
end tell
APPLE
echo "→ clipboard contains $SENTINEL"
