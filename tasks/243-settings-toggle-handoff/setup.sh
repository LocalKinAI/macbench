#!/usr/bin/env bash
set -uo pipefail
mkdir -p "$HOME/.kinbench"
PRE="$(defaults -currentHost read com.apple.coreservices.useractivityd ActivityAdvertisingAllowed 2>/dev/null || echo "1")"
echo "$PRE" > "$HOME/.kinbench/243-pre-handoff"
echo "→ pre-handoff: $PRE (1=allowed, 0=blocked)"
