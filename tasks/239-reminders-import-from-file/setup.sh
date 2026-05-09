#!/usr/bin/env bash
mkdir -p "$HOME/Desktop/kinbench"
cat > "$HOME/Desktop/kinbench/239-checklist.md" <<'MD'
- [ ] Buy milk 239
- [ ] Pick up dry cleaning 239
- [ ] Call dentist 239
MD
osascript <<'APPLE' 2>/dev/null || true
tell application "Reminders"
    try
        delete (first list whose name = "kinbench-imported")
    end try
    make new list with properties {name:"kinbench-imported"}
end tell
APPLE
echo "→ wrote 239-checklist.md (3 unchecked items) + empty kinbench-imported list"
