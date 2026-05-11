#!/usr/bin/env bash
set -uo pipefail
PRE="$(cat "$HOME/.kinbench/258-pre-inputs" 2>/dev/null | tr -d '[:space:]')"
[[ -z "$PRE" ]] && PRE=2
POST="$(defaults read com.apple.HIToolbox AppleEnabledInputSources 2>/dev/null | grep -c 'KeyboardLayout Name\|InputSourceKind' || echo 1)"
[[ -z "$POST" ]] && POST=1
echo "pre: $PRE   post: $POST"
if [[ "$POST" -lt "$PRE" ]]; then
  echo "PASS: input source removed ($PRE -> $POST)"
  exit 0
fi
echo "FAIL: input source count not reduced"
exit 1
