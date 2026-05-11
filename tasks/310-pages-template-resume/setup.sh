#!/usr/bin/env bash
set -euo pipefail
mkdir -p "$HOME/Desktop/kinbench"
rm -rf "$HOME/Desktop/kinbench/310-resume.pages"
rm -f "$HOME/Desktop/kinbench/310-resume-confirm.txt"
# Quit Pages so the agent starts cleanly with the template chooser.
osascript -e 'tell application "Pages" to quit' >/dev/null 2>&1 || true
sleep 0.4
echo "→ cleared 310-resume.pages, ready for template chooser"
