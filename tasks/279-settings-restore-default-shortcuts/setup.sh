#!/usr/bin/env bash
# Inject a sentinel custom shortcut (key 9999) so the agent must restore
# defaults — that wipes it.
set -uo pipefail
mkdir -p "$HOME/.kinbench"
# Inject a fake symbolichotkey entry to force a non-default state
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 9999 '
{
  enabled = 1;
  value = { parameters = (65535, 18, 786432); type = "standard"; };
}' 2>/dev/null || true
echo "→ injected sentinel symbolichotkey 9999"
