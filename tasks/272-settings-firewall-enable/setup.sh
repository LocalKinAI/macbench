#!/usr/bin/env bash
set -uo pipefail
mkdir -p "$HOME/.kinbench"
PRE="$(defaults read /Library/Preferences/com.apple.alf globalstate 2>/dev/null || echo "0")"
echo "$PRE" > "$HOME/.kinbench/272-pre-fw"
echo "→ pre-firewall-globalstate: $PRE (0=off, 1=on, 2=stealth)"
