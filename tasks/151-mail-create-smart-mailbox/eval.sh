#!/usr/bin/env bash
set -uo pipefail
sleep 1
SPLIST=$(/bin/ls -1 "$HOME/Library/Mail/"V*/MailData/SmartMailboxes.plist 2>/dev/null | /usr/bin/head -1)
if [[ -n "$SPLIST" ]] && /usr/bin/grep -aq "KinBench This Month" "$SPLIST" 2>/dev/null; then
  echo "PASS: smart mailbox found in $SPLIST"
  exit 0
fi
F="$HOME/Desktop/kinbench/151-smart-confirm.txt"
if [[ -f "$F" ]] && /usr/bin/grep -q "smart-mailbox-created" "$F"; then
  echo "PASS (soft): confirmation present"
  exit 0
fi
echo "FAIL"
exit 1
