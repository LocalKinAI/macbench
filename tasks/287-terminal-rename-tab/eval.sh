#!/usr/bin/env bash
set -uo pipefail
sleep 1
TITLE="$(osascript <<'APPLE' 2>/dev/null
tell application "Terminal"
    try
        return custom title of selected tab of front window
    on error
        return ""
    end try
end tell
APPLE
)"
echo "custom title: '$TITLE'"
if [[ "$TITLE" == "KinBench 287" ]]; then
  echo "PASS: tab renamed exactly"
  exit 0
fi

# Soft pass: a name attribute or window title contains the marker
ANY="$(osascript <<'APPLE' 2>/dev/null
tell application "Terminal"
    try
        return name of selected tab of front window
    on error
        return ""
    end try
end tell
APPLE
)"
echo "tab name: '$ANY'"
if [[ "$ANY" == *"KinBench 287"* ]]; then
  echo "PASS (soft): KinBench 287 visible in tab name"
  exit 0
fi
echo "FAIL: tab title not set to 'KinBench 287'"
exit 1
