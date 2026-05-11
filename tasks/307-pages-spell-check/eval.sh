#!/usr/bin/env bash
# Soft-pass: spell-check is a stateful UI action that doesn't leave a durable
# trace in the .pages file unless words are accepted/changed. Accept the
# agent's confirmation file as evidence.
set -uo pipefail
CONF="$HOME/Desktop/kinbench/307-spellcheck-confirm.txt"

if [[ -f "$CONF" ]]; then
  echo "PASS (soft): spell-check confirmation present"
  exit 0
fi
echo "FAIL: no confirmation file at $CONF"
exit 2
