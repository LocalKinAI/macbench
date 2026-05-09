#!/usr/bin/env bash
# 004-settings-dark-mode eval
#
# Pass criteria: defaults read -g AppleInterfaceStyle == "Dark".
# This is the canonical macOS appearance flag.

set -uo pipefail

MODE="$(defaults read -g AppleInterfaceStyle 2>/dev/null || echo Light)"
echo "AppleInterfaceStyle: $MODE"

if [[ "$MODE" == "Dark" ]]; then
  echo "PASS: switched to Dark Mode"
  exit 0
fi

echo "FAIL: expected 'Dark', got '$MODE'"
exit 1
