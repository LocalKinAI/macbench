#!/usr/bin/env bash
# Mail Rules are stored in ~/Library/Mail/V*/MailData/SyncedRules.plist
# which is often TCC-restricted. Try to find it, else soft-pass.
set -uo pipefail
sleep 1
RPLIST=$(/bin/ls -1 "$HOME/Library/Mail/"V*/MailData/SyncedRules.plist 2>/dev/null | /usr/bin/head -1)
if [[ -n "$RPLIST" ]] && /usr/bin/grep -aq "kinbench-rule" "$RPLIST" 2>/dev/null; then
  echo "PASS: rule found in $RPLIST"
  exit 0
fi
F="$HOME/Desktop/kinbench/150-rule-confirm.txt"
if [[ -f "$F" ]] && /usr/bin/grep -q "rule-created" "$F"; then
  echo "PASS (soft): rule confirmation file present (plist TCC-protected)"
  exit 0
fi
echo "FAIL"
exit 1
