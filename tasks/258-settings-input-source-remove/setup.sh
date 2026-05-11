#!/usr/bin/env bash
# Add a second input source so the user has something to remove.
# Use ABC (British) — KeyboardLayout id 250.
set -uo pipefail
mkdir -p "$HOME/.kinbench"

# Record count BEFORE injecting the extra source
PRE_RAW="$(defaults read com.apple.HIToolbox AppleEnabledInputSources 2>/dev/null | grep -c 'KeyboardLayout Name\|InputSourceKind' || echo 1)"
[[ -z "$PRE_RAW" ]] && PRE_RAW=1

# Best-effort: inject a British layout if not already present.
# We use plutil to insert into the array; quiet-fail if locked by TCC.
EXISTING="$(defaults read com.apple.HIToolbox AppleEnabledInputSources 2>/dev/null || echo '')"
if ! echo "$EXISTING" | grep -q '"British"'; then
  defaults write com.apple.HIToolbox AppleEnabledInputSources -array-add '<dict><key>InputSourceKind</key><string>Keyboard Layout</string><key>KeyboardLayout ID</key><integer>250</integer><key>KeyboardLayout Name</key><string>British</string></dict>' 2>/dev/null || true
fi

# Re-count after injection: that's our "pre-state" the agent must reduce.
COUNT="$(defaults read com.apple.HIToolbox AppleEnabledInputSources 2>/dev/null | grep -c 'KeyboardLayout Name\|InputSourceKind' || echo 1)"
[[ -z "$COUNT" ]] && COUNT=1
echo "$COUNT" > "$HOME/.kinbench/258-pre-inputs"
echo "→ pre-input-source-count: $COUNT (was $PRE_RAW before injection)"
