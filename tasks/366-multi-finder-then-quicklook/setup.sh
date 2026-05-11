#!/usr/bin/env bash
set -uo pipefail
mkdir -p "$HOME/Desktop/kinbench"
rm -f "$HOME/Desktop/kinbench/366-shot.png"
PDF="$HOME/Desktop/kinbench/366-doc.pdf"
# Plant a small valid PDF (so the task is deterministic, not dependent on
# whatever's in ~/Documents).
if [[ ! -f "$PDF" ]]; then
  echo "KinBench 366 placeholder for Preview" > /tmp/366-src.txt
  /usr/sbin/cupsfilter -i text/plain /tmp/366-src.txt > "$PDF" 2>/dev/null || true
  if [[ ! -s "$PDF" ]]; then
    # Tiny hand-rolled PDF as last resort
    printf '%%PDF-1.1\n1 0 obj<</Type/Catalog/Pages 2 0 R>>endobj\n2 0 obj<</Type/Pages/Kids[3 0 R]/Count 1>>endobj\n3 0 obj<</Type/Page/Parent 2 0 R/MediaBox[0 0 100 100]/Contents 4 0 R>>endobj\n4 0 obj<</Length 33>>stream\nBT /F1 12 Tf 10 50 Td (KB366) Tj ET\nendstream\nendobj\nxref\n0 5\n0000000000 65535 f\n0000000009 00000 n\n0000000053 00000 n\n0000000098 00000 n\n0000000170 00000 n\ntrailer<</Size 5/Root 1 0 R>>\nstartxref\n252\n%%EOF\n' > "$PDF"
  fi
fi
echo "→ planted $PDF ($(stat -f %z "$PDF" 2>/dev/null) bytes)"
