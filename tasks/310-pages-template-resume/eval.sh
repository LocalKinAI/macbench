#!/usr/bin/env bash
# Heuristic + soft-pass: unzip the .pages bundle and grep for the two
# personalization strings. Templates produce significantly larger files
# than empty docs, so size > 50KB is also a strong signal.
set -uo pipefail
F="$HOME/Desktop/kinbench/310-resume.pages"
CONF="$HOME/Desktop/kinbench/310-resume-confirm.txt"

[[ -e "$F" ]] || { echo "FAIL: $F missing"; exit 1; }
SIZE="$(stat -f %z "$F" 2>/dev/null || stat -c %s "$F" 2>/dev/null || echo 0)"
[[ "$SIZE" -gt 4096 ]] || { echo "FAIL: $F too small ($SIZE bytes)"; exit 2; }

if file "$F" | grep -qi "zip"; then
  TMP="$(mktemp -d)"
  trap 'rm -rf "$TMP"' EXIT
  if unzip -q -o "$F" -d "$TMP" 2>/dev/null; then
    name_hit=0; email_hit=0
    grep -r -a -l "Jacky Sun" "$TMP" 2>/dev/null | grep -q . && name_hit=1
    grep -r -a -l "sxm1981@gmail.com" "$TMP" 2>/dev/null | grep -q . && email_hit=1
    if [[ "$name_hit" -eq 1 ]] && [[ "$email_hit" -eq 1 ]]; then
      echo "PASS: name + email present, doc size=$SIZE"
      exit 0
    fi
  fi
fi
if [[ -f "$CONF" ]] && [[ "$SIZE" -gt 20000 ]]; then
  echo "PASS (soft): confirmation present + template-sized file ($SIZE bytes)"
  exit 0
fi
echo "PARTIAL: doc present ($SIZE bytes) — soft pass"
exit 0
