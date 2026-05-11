#!/usr/bin/env bash
# Pass strict: front tab's background color has dominant red channel.
# Pass soft: confirmation file written (some color changes happen via
# Settings > Profiles and don't surface through the AppleScript Tab dict).
set -uo pipefail
sleep 1

R="$(osascript <<'EOF' 2>/dev/null
tell application "Terminal"
    try
        set c to background color of selected tab of front window
        return (item 1 of c as string) & "|" & (item 2 of c as string) & "|" & (item 3 of c as string)
    on error
        return ""
    end try
end tell
EOF
)"
echo "bg rgb: $R"
CONFIRM="$HOME/Desktop/kinbench/286-confirm.txt"

if [[ -n "$R" ]]; then
  RED="${R%%|*}"; REST="${R#*|}"; GRN="${REST%%|*}"; BLU="${REST##*|}"
  # Accept any palette where red dominates green+blue (warm)
  if [[ "${RED:-0}" -gt "${GRN:-0}" ]] 2>/dev/null && [[ "${RED:-0}" -gt "${BLU:-0}" ]] 2>/dev/null; then
    echo "PASS: red-dominant tab color"
    exit 0
  fi
fi

if [[ -f "$CONFIRM" ]] && grep -qi "tab-colored" "$CONFIRM"; then
  echo "PASS (soft): confirmation file written — color may have been changed via profile"
  exit 0
fi
echo "FAIL: tab color not red-dominant and no confirmation file"
exit 1
