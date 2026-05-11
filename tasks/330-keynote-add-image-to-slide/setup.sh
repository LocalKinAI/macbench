#!/usr/bin/env bash
set -euo pipefail
mkdir -p "$HOME/Desktop/kinbench"
rm -rf "$HOME/Desktop/kinbench/330-deck.key"
rm -f "$HOME/Desktop/kinbench/330-photo.jpg"
rm -f "$HOME/Desktop/kinbench/330-image-confirm.txt"

# 1x1 red JPEG via PNG -> sips
TMP_PNG="$(mktemp -t kinbench-330).png"
python3 - <<'PY' "$TMP_PNG"
import sys, base64
data = base64.b64decode(
  "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8DwHwAFBQIAX8jx2gAAAABJRU5ErkJggg=="
)
with open(sys.argv[1], "wb") as f:
    f.write(data)
PY
sips -s format jpeg "$TMP_PNG" --out "$HOME/Desktop/kinbench/330-photo.jpg" >/dev/null 2>&1 || cp "$TMP_PNG" "$HOME/Desktop/kinbench/330-photo.jpg"
rm -f "$TMP_PNG"

OUT="$HOME/Desktop/kinbench/330-deck.key"
osascript <<APPLE >/dev/null 2>&1
tell application "Keynote"
    activate
    set d to make new document
    delay 0.6
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
echo "→ prepared 330-deck.key + 330-photo.jpg"
