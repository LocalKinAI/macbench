#!/usr/bin/env bash
# 230-reminders-attach-image setup
#
# Plants a fixture image and a target reminder. Records a baseline of
# Reminders storage size so eval can detect that an attachment landed.
set -uo pipefail

SANDBOX="$HOME/Desktop/kinbench"
IMG="$SANDBOX/230-img.jpg"
BASELINE="$SANDBOX/230-baseline.txt"
mkdir -p "$SANDBOX"

# Create a tiny but valid JPEG fixture (a 2x2 red square via sips fallback).
if [[ ! -s "$IMG" ]]; then
  # Use a portable minimal JPEG payload via base64
  /usr/bin/base64 -D > "$IMG" <<'B64' 2>/dev/null || true
/9j/4AAQSkZJRgABAQEASABIAAD/2wBDAAEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEB
AQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQH/2wBDAQEBAQEBAQEBAQEBAQEBAQEBAQEB
AQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQH/wAARCAACAAIDASIA
AhEBAxEB/8QAFAABAAAAAAAAAAAAAAAAAAAACf/EABQQAQAAAAAAAAAAAAAAAAAAAAD/xAAUAQEA
AAAAAAAAAAAAAAAAAAAA/8QAFBEBAAAAAAAAAAAAAAAAAAAAAP/aAAwDAQACEQMRAD8AVMH/2Q==
B64
fi
if [[ ! -s "$IMG" ]]; then
  # Fallback: copy any system image, or write garbage so file exists for the agent
  /usr/bin/sips -s format jpeg /System/Library/CoreServices/DefaultDesktop.heic --out "$IMG" 2>/dev/null \
    || printf 'JPEG placeholder for KinBench 230' > "$IMG"
fi

# Compute baseline size of Reminders' attachment store. Modern Reminders uses
# CloudKit; the local cache lives under ~/Library/Reminders or ~/Library/Group Containers.
SIZE_BEFORE="$(/usr/bin/du -sk "$HOME/Library/Reminders" 2>/dev/null | /usr/bin/awk '{print $1}')"
[ -z "$SIZE_BEFORE" ] && SIZE_BEFORE=0
printf '%s\n' "$SIZE_BEFORE" > "$BASELINE"

/usr/bin/osascript <<'APPLE' 2>/dev/null || true
tell application "Reminders"
    repeat with lst in lists
        try
            repeat with r in (every reminder of lst whose name = "KinBench Image 230")
                delete r
            end repeat
        end try
    end repeat
    tell default list
        make new reminder with properties {name:"KinBench Image 230"}
    end tell
end tell
APPLE
echo "→ planted reminder + fixture image ($IMG); baseline=${SIZE_BEFORE}k"
