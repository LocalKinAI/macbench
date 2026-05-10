#!/usr/bin/env bash
# Custom-icon detection: Finder sets two complementary signals
#   1. SetFile -a C → the kHasCustomIcon Finder flag (GetFileInfo -a C reports it)
#   2. An invisible "Icon\r" file inside the folder containing the icon
# Either is sufficient to call the task complete; we accept whichever is present.
set -uo pipefail
TARGET="$HOME/Desktop/kinbench/069-folder"
[[ -d "$TARGET" ]] || { echo "FAIL: target folder missing"; exit 1; }

# Check Finder flag
FLAG="$(/usr/bin/GetFileInfo -aC "$TARGET" 2>/dev/null || echo "?")"
echo "kHasCustomIcon flag: $FLAG"

# Check Icon\r file
ICON_FILE="$TARGET/Icon"$'\r'
if [[ -f "$ICON_FILE" ]]; then
  ICON_SIZE=$(/usr/bin/stat -f %z "$ICON_FILE" 2>/dev/null || echo 0)
  echo "Icon\\r file: present ($ICON_SIZE bytes)"
else
  echo "Icon\\r file: absent"
fi

if [[ "$FLAG" == "1" ]]; then
  echo "PASS: kHasCustomIcon flag is set"
  exit 0
fi
if [[ -f "$ICON_FILE" ]]; then
  echo "PASS: Icon\\r file exists in folder (custom icon attached)"
  exit 0
fi
echo "FAIL: neither kHasCustomIcon flag nor Icon\\r file present"
exit 2
