#!/usr/bin/env bash
# Setup: create a .pages file + a test JPEG image. Open the doc for the agent.
set -euo pipefail
mkdir -p "$HOME/Desktop/kinbench"
rm -rf "$HOME/Desktop/kinbench/299-doc.pages"
rm -f "$HOME/Desktop/kinbench/299-photo.jpg"
rm -f "$HOME/Desktop/kinbench/299-image-confirm.txt"

# Generate a minimal-yet-valid JPEG by using sips on a screenshot, or fall back
# to a generated solid-color image via sips.
TMP_PNG="$(mktemp -t kinbench-299).png"
# Use a tiny PNG built via base64 (1x1 red pixel) then convert to JPG via sips.
python3 - <<'PY' "$TMP_PNG"
import sys, base64
# 1x1 red PNG
data = base64.b64decode(
  "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8DwHwAFBQIAX8jx2gAAAABJRU5ErkJggg=="
)
with open(sys.argv[1], "wb") as f:
    f.write(data)
PY

# Convert PNG to JPG; sips is preinstalled
sips -s format jpeg "$TMP_PNG" --out "$HOME/Desktop/kinbench/299-photo.jpg" >/dev/null 2>&1 || cp "$TMP_PNG" "$HOME/Desktop/kinbench/299-photo.jpg"
rm -f "$TMP_PNG"

# Create the Pages doc
OUT="$HOME/Desktop/kinbench/299-doc.pages"
osascript <<APPLE >/dev/null 2>&1
tell application "Pages"
    activate
    set d to make new document
    delay 0.6
    try
        set body text of d to "KinBench 299 — please insert an image into this document."
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
echo "→ prepared 299-doc.pages + 299-photo.jpg"
