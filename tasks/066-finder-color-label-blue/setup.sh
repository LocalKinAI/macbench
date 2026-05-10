#!/usr/bin/env bash
set -uo pipefail
SANDBOX="$HOME/Desktop/kinbench"
mkdir -p "$SANDBOX"
F="$SANDBOX/066-target.txt"
printf 'kinbench-066 target\n' > "$F"
xattr -d com.apple.metadata:_kMDItemUserTags "$F" 2>/dev/null || true
echo "→ $F prepared"
