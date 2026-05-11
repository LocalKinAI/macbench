#!/usr/bin/env bash
# Kill any running Maps so we can detect it being launched.
osascript -e 'tell application "Maps" to quit' 2>/dev/null || true
sleep 0.8
pkill -x Maps 2>/dev/null || true
echo "-> Maps closed"
