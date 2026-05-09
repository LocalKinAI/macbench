#!/usr/bin/env bash
osascript -e 'tell application "Notes" to repeat with f in (every folder whose name = "kinbench-folder") to delete f' 2>/dev/null || true
