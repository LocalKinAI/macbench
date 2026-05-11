#!/usr/bin/env bash
# Count current enabled input sources.
set -uo pipefail
mkdir -p "$HOME/.kinbench"
COUNT="$(defaults read com.apple.HIToolbox AppleEnabledInputSources 2>/dev/null | grep -c 'KeyboardLayout Name\|InputSourceKind' || echo 1)"
[[ -z "$COUNT" ]] && COUNT=1
echo "$COUNT" > "$HOME/.kinbench/257-pre-inputs"
echo "→ pre-input-source-count: $COUNT"
