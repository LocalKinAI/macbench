#!/usr/bin/env bash
set -uo pipefail
SANDBOX="$HOME/Desktop/kinbench"
mkdir -p "$SANDBOX"
F="$SANDBOX/064-multi-tag.txt"
printf 'kinbench-064 target\n' > "$F"
xattr -d com.apple.metadata:_kMDItemUserTags "$F" 2>/dev/null || true
echo "→ $TARGET_FILE prepared"
