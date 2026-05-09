#!/usr/bin/env bash
set -euo pipefail
SANDBOX="$HOME/Desktop/kinbench"
mkdir -p "$SANDBOX"
F="$SANDBOX/031-tag-me.txt"
printf 'kinbench-031 untagged\n' > "$F"
xattr -d "com.apple.metadata:_kMDItemUserTags" "$F" 2>/dev/null || true
echo "→ wrote $F (tags cleared)"
