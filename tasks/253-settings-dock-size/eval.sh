#!/usr/bin/env bash
set -uo pipefail
POST="$(defaults read com.apple.dock tilesize 2>/dev/null || echo "48")"
echo "post tilesize: $POST"
# Pass if size is now < 32 (clearly smaller, the smallest dock size is 16)
POST_INT=${POST%%.*}
if [[ "$POST_INT" -le 32 ]] 2>/dev/null && [[ "$POST" != "48" && "$POST" != "48.0" ]]; then
  echo "PASS: dock resized smaller"; exit 0
fi
echo "FAIL: tilesize unchanged or not smaller"
exit 1
