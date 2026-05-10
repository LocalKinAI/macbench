#!/usr/bin/env bash
set -uo pipefail
F="$HOME/Desktop/kinbench/181-tagged-titles.txt"
[[ -f "$F" ]] || { echo "FAIL: $F missing"; exit 1; }
content="$(cat "$F")"
echo "file content:"
printf '%s\n' "$content" | sed 's/^/  | /'

has_alpha=0; has_bravo=0; has_charlie=0
printf '%s' "$content" | grep -qF "KinBench Tag181 alpha"   && has_alpha=1
printf '%s' "$content" | grep -qF "KinBench Tag181 bravo"   && has_bravo=1
printf '%s' "$content" | grep -qF "KinBench Tag181 charlie" && has_charlie=1

if [[ $has_alpha -eq 1 && $has_charlie -eq 1 && $has_bravo -eq 0 ]]; then
  echo "PASS: alpha + charlie listed, bravo correctly excluded"
  exit 0
fi
echo "FAIL: expected exactly {alpha, charlie}; got alpha=$has_alpha bravo=$has_bravo charlie=$has_charlie"
exit 1
