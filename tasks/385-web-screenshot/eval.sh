#!/usr/bin/env bash
set -uo pipefail
OUT="$HOME/Desktop/kinbench/385-shot.png"
[[ -f "$OUT" ]] || { echo "FAIL: $OUT missing"; exit 1; }
sz=$(stat -f%z "$OUT" 2>/dev/null)
echo "size: ${sz} bytes"
[[ "$sz" -lt 1000 ]] && { echo "FAIL: png too small"; exit 2; }
# PNG magic bytes: 89 50 4E 47
hdr=$(head -c 4 "$OUT" | xxd -p)
echo "magic: $hdr"
if [[ "$hdr" == "89504e47" ]]; then
  echo "PASS: valid PNG"
  exit 0
fi
echo "FAIL: not a PNG"
exit 3
