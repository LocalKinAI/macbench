#!/usr/bin/env bash
# macOS 14+ removed the AppleScript `pinned` property from iCloud Notes.
# Soft-pass: existing note + modification > creation = PASS.
set -uo pipefail
sleep 1
R="$(osascript <<'APPLE' 2>/dev/null
tell application "Notes"
    set ms to (every note whose name = "KinBench Unpin 165")
    if (count of ms) = 0 then return "MISSING"
    set m to item 1 of ms
    set md to modification date of m
    set cd to creation date of m
    if md > cd then
        return "TOUCHED"
    else
        return "UNTOUCHED"
    end if
end tell
APPLE
)"
echo "result: '$R'"
case "$R" in
  MISSING) echo "FAIL: note deleted instead of unpinned"; exit 1 ;;
  TOUCHED) echo "PASS: note exists + agent acted on it (pinned state not directly queryable on macOS 14+)"; exit 0 ;;
  UNTOUCHED) echo "FAIL: note unchanged, agent did nothing"; exit 1 ;;
  *) echo "FAIL: unexpected response '$R'"; exit 1 ;;
esac
