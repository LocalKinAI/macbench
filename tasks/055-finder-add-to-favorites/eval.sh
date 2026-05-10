#!/usr/bin/env bash
# Sidebar Favorites plist (~/Library/Application Support/com.apple.sharedfilelist/
# com.apple.LSSharedFileList.FavoriteItems.sfl3) is TCC-protected and not
# directly queryable from a non-Full-Disk-Access shell. Soft-pass: the agent
# is asked to also write a confirmation file at ~/Desktop/kinbench/055-favorites-confirm.txt
# whose content is the absolute folder path. That's a paper trail: if the file
# is missing the agent didn't even understand the prompt; if it has the right
# path we trust the agent did the sidebar action.
set -uo pipefail
SANDBOX="$HOME/Desktop/kinbench"
F="$SANDBOX/055-favorites-confirm.txt"
[[ -d "$SANDBOX" ]] || { echo "FAIL: $SANDBOX missing"; exit 1; }
[[ -f "$F" ]] || { echo "FAIL: confirmation file $F missing"; exit 2; }
content="$(/bin/cat "$F" | /usr/bin/tr -d '[:space:]')"
echo "confirmation content: $content"
# Accept any non-empty path that includes "kinbench"
if printf '%s' "$content" | /usr/bin/grep -q "kinbench"; then
  echo "PASS: confirmation written (sidebar plist not directly verifiable on macOS due to TCC)"
  exit 0
fi
echo "FAIL: confirmation file empty or missing 'kinbench' string"
exit 3
