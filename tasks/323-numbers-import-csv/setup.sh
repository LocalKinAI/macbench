#!/usr/bin/env bash
set -euo pipefail
mkdir -p "$HOME/Desktop/kinbench"
rm -f "$HOME/Desktop/kinbench/323-data.csv"
rm -rf "$HOME/Desktop/kinbench/323-imported.numbers"
rm -f "$HOME/Desktop/kinbench/323-csv-confirm.txt"

cat > "$HOME/Desktop/kinbench/323-data.csv" <<'CSV'
Name,Quantity,Price
Apple,5,1.20
Banana,12,0.40
Cherry,30,0.10
Date,7,2.50
Elderberry,3,4.99
CSV

osascript -e 'tell application "Numbers" to quit' >/dev/null 2>&1 || true
sleep 0.4
echo "→ wrote 323-data.csv, cleared 323-imported.numbers"
