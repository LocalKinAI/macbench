#!/usr/bin/env bash
set -euo pipefail
mkdir -p "$HOME/Desktop/kinbench"
rm -rf "$HOME/Desktop/kinbench/333-deck.key"
rm -f "$HOME/Desktop/kinbench/333-rearrange-confirm.txt"

OUT="$HOME/Desktop/kinbench/333-deck.key"
osascript <<APPLE >/dev/null 2>&1
tell application "Keynote"
    activate
    set d to make new document
    delay 0.6
    try
        tell d
            try
                set object text of (first text item of (first slide)) to "Slide1"
            end try
            set s2 to make new slide
            try
                set object text of (first text item of s2) to "Slide2"
            end try
            set s3 to make new slide
            try
                set object text of (first text item of s3) to "Slide3"
            end try
        end tell
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
open -a Keynote "$OUT" 2>/dev/null || true
echo "→ prepared 333-deck.key (3 slides labelled)"
