#!/usr/bin/env bash
set -euo pipefail
mkdir -p "$HOME/Desktop/kinbench"
rm -rf "$HOME/Desktop/kinbench/303-doc.pages"
rm -f "$HOME/Desktop/kinbench/303-font-confirm.txt"

OUT="$HOME/Desktop/kinbench/303-doc.pages"
osascript <<APPLE >/dev/null 2>&1
tell application "Pages"
    activate
    set d to make new document
    delay 0.5
    try
        set body text of d to "KinBench 303 — change my font to Helvetica 14pt."
    end try
    delay 0.3
    try
        save d in (POSIX file "$OUT")
    end try
    delay 0.5
    try
        close d saving yes
    end try
end tell
APPLE
sleep 0.5
open -a Pages "$OUT" 2>/dev/null || true
echo "→ prepared 303-doc.pages"
