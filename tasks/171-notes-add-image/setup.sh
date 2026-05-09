#!/usr/bin/env bash
mkdir -p "$HOME/Desktop/kinbench"
# Generate a tiny test image (1x1 PNG via printf+base64)
printf '\x89PNG\r\n\x1a\n\x00\x00\x00\rIHDR\x00\x00\x00\x01\x00\x00\x00\x01\x08\x06\x00\x00\x00\x1f\x15\xc4\x89\x00\x00\x00\rIDATx\x9cc\xf8\xff\xff?\x00\x05\xfe\x02\xfeA\x9bU%\x00\x00\x00\x00IEND\xaeB`\x82' > "$HOME/Desktop/kinbench/171-photo.jpg" 2>/dev/null
osascript <<'APPLE' 2>/dev/null || true
tell application "Notes"
    repeat with n in (every note whose name = "KinBench Image 171")
        delete n
    end repeat
    make new note with properties {name:"KinBench Image 171", body:"image will go here"}
end tell
APPLE
