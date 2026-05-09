#!/usr/bin/env bash
set -uo pipefail
sleep 1
PRE_N="$(osascript -e 'tell application "Reminders" to count of (every list whose name = "kinbench-rename-pre")' 2>/dev/null)"
POST_N="$(osascript -e 'tell application "Reminders" to count of (every list whose name = "kinbench-rename-post")' 2>/dev/null)"
echo "pre-count: $PRE_N  post-count: $POST_N"
if [[ "$PRE_N" == "0" && "$POST_N" -ge 1 ]]; then echo "PASS"; exit 0; fi
echo "FAIL"
exit 1
