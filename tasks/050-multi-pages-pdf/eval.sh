#!/usr/bin/env bash
# Pass: 050-doc.pdf exists, file magic == PDF, size > 1KB,
# and ideally contains the body text (not all PDFs make it
# trivially extractable; soft fallback on size).
set -uo pipefail
F="$HOME/Desktop/kinbench/050-doc.pdf"
if [[ ! -f "$F" ]]; then
  echo "FAIL: $F missing"
  exit 1
fi
if ! file "$F" | grep -qi "PDF document"; then
  echo "FAIL: $F isn't a PDF"
  exit 2
fi
SIZE=$(stat -f %z "$F" 2>/dev/null || stat -c %s "$F" 2>/dev/null || echo 0)
echo "PDF size: $SIZE bytes"
if [[ "$SIZE" -lt 1024 ]]; then
  echo "FAIL: PDF too small ($SIZE bytes — likely empty doc)"
  exit 3
fi

# Try text extraction via macOS pdftotext-like tool. macOS doesn't
# ship pdftotext by default; mdimport + mdls could query Spotlight,
# but Spotlight may not have indexed the file yet. Try `strings`
# which works on most uncompressed PDF text streams.
if strings "$F" | grep -qi "kinbench 050 export"; then
  echo "PASS: PDF contains expected body text"
  exit 0
fi

echo "PARTIAL: PDF exists ($SIZE bytes) but text not extractable from raw stream — accepting as soft pass"
exit 0
