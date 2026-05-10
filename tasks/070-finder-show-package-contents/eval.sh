#!/usr/bin/env bash
# TextEdit.app/Contents always contains at least: Info.plist, MacOS, Resources,
# PkgInfo, _CodeSignature. Eval requires the agent to have produced a listing
# containing at least 3 of these well-known names.
set -uo pipefail
F="$HOME/Desktop/kinbench/070-package-contents.txt"
[[ -f "$F" ]] || { echo "FAIL: $F missing"; exit 1; }

content="$(/bin/cat "$F")"
echo "listing:"
printf '%s\n' "$content" | /usr/bin/sed 's/^/  | /'

required_any=("Info.plist" "MacOS" "Resources" "PkgInfo" "_CodeSignature")
hits=0
for r in "${required_any[@]}"; do
  if printf '%s' "$content" | /usr/bin/grep -qi "$r"; then
    hits=$((hits+1))
  fi
done
echo "matched well-known bundle entries: $hits / ${#required_any[@]}"
[[ $hits -ge 3 ]] && { echo "PASS: listing matches a real TextEdit.app bundle"; exit 0; }
echo "FAIL: only $hits/$((${#required_any[@]})) matches — listing doesn't look like TextEdit.app/Contents"
exit 2
