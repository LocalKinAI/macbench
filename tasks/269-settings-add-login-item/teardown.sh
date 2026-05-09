#!/usr/bin/env bash
osascript -e 'tell application "System Events" to delete every login item whose name is "TextEdit"' 2>/dev/null || true
