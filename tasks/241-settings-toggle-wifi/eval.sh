#!/usr/bin/env bash
# Pass: Wi-Fi finishes On. Accepts whether or not we can observe the
# intermediate Off state (race-y); the agent intent is "toggle then on".
set -uo pipefail
IFACE="$(cat "$HOME/.kinbench/241-pre-wifi-iface" 2>/dev/null | tr -d '[:space:]')"
[[ -z "$IFACE" ]] && IFACE="en0"

POST="$(networksetup -getairportpower "$IFACE" 2>/dev/null | awk '{print $NF}')"
echo "iface=$IFACE post=$POST"
if [[ "$POST" == "On" ]]; then
  echo "PASS: Wi-Fi is On (agent may have toggled it)"
  exit 0
fi
echo "FAIL: Wi-Fi not On (got '$POST')"
exit 1
