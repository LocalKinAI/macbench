#!/usr/bin/env bash
# Pass: front window's current settings name is not the baseline (i.e.
# a different built-in profile was applied).
set -uo pipefail
sleep 1
BASELINE="$(cat "$HOME/Desktop/kinbench/289-baseline.txt" 2>/dev/null | tr -d '\n' || echo Basic)"
CUR="$(osascript <<'APPLE' 2>/dev/null
tell application "Terminal"
    try
        return name of current settings of selected tab of front window
    on error
        return ""
    end try
end tell
APPLE
)"
CUR="$(printf '%s' "$CUR" | tr -d '\n')"
echo "baseline='$BASELINE' current='$CUR'"

if [[ -n "$CUR" ]] && [[ "$CUR" != "$BASELINE" ]]; then
  echo "PASS: profile changed ($BASELINE -> $CUR)"
  exit 0
fi
# Soft: check default settings changed app-wide
DEF="$(osascript -e 'tell application "Terminal" to return name of default settings' 2>/dev/null | tr -d '\n')"
if [[ -n "$DEF" ]] && [[ "$DEF" != "$BASELINE" ]]; then
  echo "PASS (soft): default settings changed ($BASELINE -> $DEF)"
  exit 0
fi
echo "FAIL: profile still '$BASELINE'"
exit 1
