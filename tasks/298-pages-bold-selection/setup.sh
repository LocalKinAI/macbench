#!/usr/bin/env bash
# Setup: create a .pages file containing the phrase 'KinBench 298' so the agent
# has something to bold. We use AppleScript so the file is a real Pages bundle.
set -euo pipefail
mkdir -p "$HOME/Desktop/kinbench"
rm -rf "$HOME/Desktop/kinbench/298-doc.pages"
rm -f "$HOME/Desktop/kinbench/298-bold-confirm.txt"

OUT="$HOME/Desktop/kinbench/298-doc.pages"
osascript <<APPLE >/dev/null 2>&1
tell application "Pages"
    activate
    set d to make new document
    delay 0.6
    try
        set body text of d to "KinBench 298 — please bold this phrase."
    end try
    delay 0.4
    try
        save d in (POSIX file "$OUT")
    end try
    delay 0.6
    try
        close d saving yes
    end try
end tell
APPLE

# Re-open for the agent
sleep 0.6
open -a Pages "$OUT" 2>/dev/null || true
echo "→ prepared 298-doc.pages, opened in Pages"
