#!/usr/bin/env bash
osascript -e 'tell application "Maps" to quit' 2>/dev/null || true
sleep 0.8
pkill -x Maps 2>/dev/null || true
echo "-> Maps closed"
