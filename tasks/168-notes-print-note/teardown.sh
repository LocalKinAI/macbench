#!/usr/bin/env bash
osascript -e 'tell application "Notes" to repeat with n in (every note whose name = "KinBench Print 168") to delete n' 2>/dev/null || true
