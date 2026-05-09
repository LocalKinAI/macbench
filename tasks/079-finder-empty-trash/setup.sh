#!/usr/bin/env bash
# Plant a file in Trash so eval can verify it's gone after Empty Trash.
set -uo pipefail
TRASH="$HOME/.Trash"
mkdir -p "$TRASH"
F="$TRASH/kinbench-079-doomed-$$.txt"
printf 'this should be erased\n' > "$F"
echo "→ planted $F in Trash"
