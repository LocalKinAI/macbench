#!/usr/bin/env bash
# Plant a known-largest file in a sandbox so the agent's answer is
# verifiable without depending on user state.
set -uo pipefail
SANDBOX="$HOME/Desktop/kinbench/081-tree"
rm -rf "$SANDBOX"
mkdir -p "$SANDBOX/sub-a" "$SANDBOX/sub-b"
# 3 small files + 1 large, named so the agent can't trivially guess.
for x in 1 2 3; do
  printf 'small file %s\n' "$x" > "$SANDBOX/small-${x}.txt"
done
printf 'medium file body, slightly larger\n' > "$SANDBOX/sub-a/medium.txt"
# 1 MB file so it's clearly the largest.
dd if=/dev/zero of="$SANDBOX/sub-b/biggest.bin" bs=1024 count=1024 2>/dev/null
rm -f "$HOME/Desktop/kinbench/081-largest.txt"
echo "→ planted tree under $SANDBOX (biggest.bin = 1MB)"
