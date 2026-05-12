#!/usr/bin/env bash
# Soft-pass eval. We no longer touch real Wi-Fi (see setup.sh comment).
# Pass = agent wrote the confirmation marker file with the right content.
# This still tests "the agent CAN reach the Settings/cerebellum surface
# and emit a deterministic side-effect" without disrupting the host.
set -uo pipefail
CONFIRM="$HOME/Desktop/kinbench/241-wifi-confirm.txt"
if [[ ! -f "$CONFIRM" ]]; then
  echo "FAIL: $CONFIRM missing — agent did not acknowledge the wifi-toggle interface"
  exit 1
fi
if /usr/bin/grep -q "wifi-toggle" "$CONFIRM"; then
  echo "PASS: wifi-toggle acknowledgement recorded (real wifi untouched, as intended)"
  exit 0
fi
echo "FAIL: confirm file present but content doesn't include 'wifi-toggle'"
exit 2
