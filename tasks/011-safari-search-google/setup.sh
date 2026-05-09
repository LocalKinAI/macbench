#!/usr/bin/env bash
set -uo pipefail
osascript -e 'tell application "Safari" to quit' 2>/dev/null || true
sleep 1
echo "→ Safari quit (clean slate)"
