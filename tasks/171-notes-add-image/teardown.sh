#!/usr/bin/env bash
osascript -e 'tell application "Notes" to repeat with n in (every note whose name = "KinBench Image 171") to delete n' 2>/dev/null || true
