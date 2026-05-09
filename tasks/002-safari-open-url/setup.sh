#!/usr/bin/env bash
# 002-safari-open-url setup
#
# Quits Safari (if running) so we get a clean slate. The agent
# should be able to launch Safari from scratch and navigate.

set -uo pipefail
osascript -e 'tell application "Safari" to quit' 2>/dev/null || true
# Wait for the quit to settle so AX doesn't return stale window data.
sleep 1
echo "→ Safari quit"
