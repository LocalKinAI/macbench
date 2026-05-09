#!/usr/bin/env bash
set -uo pipefail
SANDBOX="$HOME/Desktop/kinbench"
mkdir -p "$SANDBOX"
F="$SANDBOX/065-tagged.txt"
printf 'kinbench-065 target\n' > "$F"
xattr -d com.apple.metadata:_kMDItemUserTags "$F" 2>/dev/null || true
# For 'remove all tags' tasks, pre-tag the file with Red so removal is observable.
osascript <<APPLE 2>/dev/null || true
tell application "Finder"
    set f to POSIX file "$F" as alias
    set label index of f to 2
end tell
APPLE
echo "→ $TARGET_FILE prepared"
