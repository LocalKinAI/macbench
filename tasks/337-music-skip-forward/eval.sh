#!/usr/bin/env bash
set -uo pipefail
sleep 1
PRE="$(cat "$HOME/.kinbench/337-pre" 2>/dev/null)"
POST="$(osascript -e 'tell application "Music" to try
    return name of current track
on error
    return ""
end try' 2>/dev/null)"
echo "pre: $PRE  post: $POST"
if [[ -z "$PRE" && -z "$POST" ]]; then
  echo "FAIL: empty library, cannot verify"
  exit 1
fi
[[ "$POST" != "$PRE" ]] && { echo "PASS: track advanced"; exit 0; }
echo "FAIL: track unchanged"
exit 1
