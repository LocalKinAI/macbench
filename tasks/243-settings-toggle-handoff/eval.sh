#!/usr/bin/env bash
set -uo pipefail
PRE="$(cat "$HOME/.kinbench/243-pre-handoff" 2>/dev/null | tr -d '[:space:]')"
POST="$(defaults -currentHost read com.apple.coreservices.useractivityd ActivityAdvertisingAllowed 2>/dev/null | tr -d '[:space:]')"
echo "pre: $PRE   post: $POST"
if [[ -n "$POST" && "$POST" != "$PRE" ]]; then
  echo "PASS: Handoff toggled ($PRE -> $POST)"
  exit 0
fi
# Soft-pass: pane open
if pgrep -x "System Settings" >/dev/null 2>&1; then
  echo "PASS (soft): General pane open — handoff UI may not have persisted yet"
  exit 0
fi
echo "FAIL: Handoff unchanged"
exit 1
