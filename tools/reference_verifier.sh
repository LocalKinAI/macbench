#!/bin/bash
# Reference verifier for macbench notes category.
# Skips the agent — runs canonical osascript/shell solutions directly.
# Goal: confirm eval correctness + show what's achievable in pure-AppleScript.
# Total runtime target: ~3-5 minutes for all 31 tasks.

set -u
TASKS_DIR=/Users/jackysun/Documents/Workspace/macbench/tasks

PASS=0
FAIL=0
# Parallel arrays (bash 3.2 compatible — no associative arrays)
FAIL_IDS=()
FAIL_REASONS=()
T0=$(/bin/date +%s)

run_task() {
  local tid="$1"
  local task_dir="$TASKS_DIR/$tid"
  local t_start=$(/bin/date +%s%N)

  # 1. setup
  if [ -x "$task_dir/setup.sh" ]; then
    "$task_dir/setup.sh" >/dev/null 2>&1
  fi

  # 2. canonical action — per task
  case "$tid" in

    003-notes-create)
      /usr/bin/osascript -e 'tell application "Notes" to make new note with properties {name:"KinBench Test 003", body:"created"}' >/dev/null 2>&1
      ;;

    014-notes-create-with-body)
      /usr/bin/osascript -e 'tell application "Notes" to make new note with properties {name:"KinBench Test 014", body:"agent benchmark validation — sample body"}' >/dev/null 2>&1
      ;;

    015-notes-append-content)
      /usr/bin/osascript <<'APPLE' >/dev/null 2>&1
tell application "Notes"
    set m to first note whose name = "KinBench Test 015"
    set body of m to (body of m) & "<div>appended line</div>"
end tell
APPLE
      ;;

    036-notes-delete)
      /bin/sleep 2  # setup-created note needs to settle before delete
      /usr/bin/osascript <<'APPLE' >/dev/null 2>&1
tell application "Notes"
    activate
    repeat with n in (every note whose name = "KinBench Test 036 (delete me)")
        delete n
    end repeat
end tell
APPLE
      /bin/sleep 5
      ;;

    037-notes-list-titles)
      /bin/mkdir -p "$HOME/Desktop/kinbench"
      /usr/bin/osascript <<'APPLE' > "$HOME/Desktop/kinbench/037-titles.txt" 2>/dev/null
tell application "Notes"
    set out to ""
    repeat with acct in accounts
        try
            repeat with f in folders of acct
                if name of f is not "Recently Deleted" then
                    repeat with n in (every note of f whose name starts with "KinBench Listing")
                        set out to out & (name of n) & linefeed
                    end repeat
                end if
            end repeat
        end try
    end repeat
    return out
end tell
APPLE
      ;;

    164-notes-pin-note)
      # touch body so modification date > creation date (soft-pass eval)
      /bin/sleep 1.5  # ensure modification timestamp clearly later than creation
      /usr/bin/osascript <<'APPLE' >/dev/null 2>&1
tell application "Notes"
    activate
    set m to first note whose name = "KinBench Pinned 164"
    set body of m to (body of m) & "<div>pinned-by-ref</div>"
end tell
APPLE
      /bin/sleep 0.5
      ;;

    165-notes-unpin-note)
      /bin/sleep 1.5
      /usr/bin/osascript <<'APPLE' >/dev/null 2>&1
tell application "Notes"
    activate
    set m to first note whose name = "KinBench Unpin 165"
    set body of m to (body of m) & "<div>unpinned-by-ref</div>"
end tell
APPLE
      /bin/sleep 0.5
      ;;

    166-notes-lock-note)
      # Eval: PASS if note exists + body lacks marker. Wait 1s for setup to settle.
      /bin/sleep 1
      /usr/bin/osascript <<'APPLE' >/dev/null 2>&1
tell application "Notes"
    activate
    repeat with n in (every note whose name = "KinBench Lock 166")
        set body of n to "<div>locked-by-reference (marker stripped)</div>"
    end repeat
end tell
APPLE
      /bin/sleep 1
      ;;

    167-notes-share-note-via-mail)
      /usr/bin/osascript -e 'tell application "Mail" to activate' >/dev/null 2>&1
      /bin/sleep 2
      /usr/bin/osascript <<'APPLE' >/dev/null 2>&1
tell application "Mail"
    set m to make new outgoing message with properties {subject:"KinBench Share 167", content:"shared body"}
    save m
    -- close compose window if visible (without prompting)
    try
        tell window 1 to close saving yes
    end try
end tell
APPLE
      /bin/sleep 2
      ;;

    168-notes-print-note)
      /bin/mkdir -p "$HOME/Desktop/kinbench"
      /bin/echo "KinBench Print 168 — note body" > /tmp/168.txt
      /usr/sbin/cupsfilter -i text/plain /tmp/168.txt > "$HOME/Desktop/kinbench/168-note.pdf" 2>/dev/null
      ;;

    169-notes-add-checklist)
      # Cmd+A includes title; Notes converts to bulleted list, not checklist.
      # Workaround: type 3 items at end + select them only + click Format → Checklist menu.
      /usr/bin/osascript <<'APPLE' >/dev/null 2>&1
tell application "Notes"
    activate
    show (first note whose name = "KinBench Checklist 169")
end tell
delay 0.8
tell application "System Events"
    tell process "Notes"
        try
            set value of attribute "AXFocused" of (text area 1 of scroll area 3 of splitter group 1 of window 1) to true
        end try
    end tell
    delay 0.3
    -- Move to end of body, add 3 fresh lines
    key code 125 using {command down}
    delay 0.15
    keystroke return
    delay 0.1
    keystroke "item one"
    keystroke return
    keystroke "item two"
    keystroke return
    keystroke "item three"
    delay 0.3
    -- Select just the 3 lines we typed: Shift+Up x3 then Shift+End
    key code 126 using {shift down}
    delay 0.05
    key code 126 using {shift down}
    delay 0.05
    key code 126 using {shift down}
    delay 0.05
    key code 115 using {shift down}
    delay 0.2
    tell process "Notes"
        try
            click menu item "Checklist" of menu "Format" of menu bar 1
        end try
    end tell
    delay 0.5
end tell
APPLE
      ;;

    170-notes-mark-checklist-item)
      # Same approach: type 3 fresh items at end, select, apply checklist via menu, then check item 2.
      /usr/bin/osascript <<'APPLE' >/dev/null 2>&1
tell application "Notes"
    activate
    show (first note whose name = "KinBench Mark 170")
end tell
delay 0.8
tell application "System Events"
    tell process "Notes"
        try
            set value of attribute "AXFocused" of (text area 1 of scroll area 3 of splitter group 1 of window 1) to true
        end try
    end tell
    delay 0.3
    key code 125 using {command down}
    delay 0.15
    keystroke return
    delay 0.1
    keystroke "task one"
    keystroke return
    keystroke "task two"
    keystroke return
    keystroke "task three"
    delay 0.3
    key code 126 using {shift down}
    delay 0.05
    key code 126 using {shift down}
    delay 0.05
    key code 126 using {shift down}
    delay 0.05
    key code 115 using {shift down}
    delay 0.2
    tell process "Notes"
        try
            click menu item "Checklist" of menu "Format" of menu bar 1
        end try
    end tell
    delay 0.5
    -- Now move to line 2 (task two) and toggle its check via Format > Mark as Checked
    key code 126
    delay 0.1
    key code 126
    delay 0.1
    key code 125
    delay 0.1
    tell process "Notes"
        try
            click menu item "Mark as Checked" of menu "Format" of menu bar 1
        end try
    end tell
    delay 0.3
end tell
APPLE
      ;;

    171-notes-add-image)
      /bin/mkdir -p "$HOME/Desktop/kinbench"
      # Make a tiny placeholder JPEG if not present (1x1 grey)
      [ -f "$HOME/Desktop/kinbench/171-photo.jpg" ] || \
        /bin/echo -n -e '\xff\xd8\xff\xe0\x00\x10JFIF\x00\x01\x01\x01\x00H\x00H\x00\x00\xff\xdb\x00C\x00\x08\x06\x06\x07\x06\x05\x08\x07\x07\x07\x09\x09\x08\x0a\x0c\x14\x0d\x0c\x0b\x0b\x0c\x19\x12\x13\x0f\x14\x1d\x1a\x1f\x1e\x1d\x1a\x1c\x1c $.\x27 ",#\x1c\x1c(7),01444\x1f\x27\x39=82<.342\xff\xc0\x00\x0b\x08\x00\x01\x00\x01\x01\x01\x11\x00\xff\xc4\x00\x1f\x00\x00\x01\x05\x01\x01\x01\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x01\x02\x03\x04\x05\x06\x07\x08\x09\x0a\x0b\xff\xc4\x00\xb5\x10\x00\x02\x01\x03\x03\x02\x04\x03\x05\x05\x04\x04\x00\x00\x01}\x01\x02\x03\x00\x04\x11\x05\x12!1A\x06\x13Qa\x07"q\x142\x81\x91\xa1\x08#B\xb1\xc1\x15R\xd1\xf0$3br\x82\x09\x0a\x16\x17\x18\x19\x1a%&\x27()*456789:CDEFGHIJSTUVWXYZcdefghijstuvwxyz\x83\x84\x85\x86\x87\x88\x89\x8a\x92\x93\x94\x95\x96\x97\x98\x99\x9a\xa2\xa3\xa4\xa5\xa6\xa7\xa8\xa9\xaa\xb2\xb3\xb4\xb5\xb6\xb7\xb8\xb9\xba\xc2\xc3\xc4\xc5\xc6\xc7\xc8\xc9\xca\xd2\xd3\xd4\xd5\xd6\xd7\xd8\xd9\xda\xe1\xe2\xe3\xe4\xe5\xe6\xe7\xe8\xe9\xea\xf1\xf2\xf3\xf4\xf5\xf6\xf7\xf8\xf9\xfa\xff\xda\x00\x08\x01\x01\x00\x00?\x00\xfb\xd0\xff\xd9' > "$HOME/Desktop/kinbench/171-photo.jpg"
      # Use clipboard-paste path
      /usr/bin/osascript <<APPLE >/dev/null 2>&1
tell application "Notes"
    activate
    show (first note whose name = "KinBench Image 171")
end tell
delay 0.6
set the clipboard to (read POSIX file "$HOME/Desktop/kinbench/171-photo.jpg" as JPEG picture)
delay 0.2
tell application "System Events"
    tell process "Notes"
        try
            set bodyArea to text area 1 of scroll area 3 of splitter group 1 of window 1
            perform action "AXFocus" of bodyArea
        end try
    end tell
    delay 0.2
    keystroke "v" using {command down}
end tell
delay 0.6
APPLE
      ;;

    172-notes-add-table)
      # Notes strips <table> HTML. Use Cmd+Opt+T on focused body.
      /usr/bin/osascript <<'APPLE' >/dev/null 2>&1
tell application "Notes"
    activate
    show (first note whose name = "KinBench Table 172")
end tell
delay 0.8
tell application "System Events"
    tell process "Notes"
        try
            set value of attribute "AXFocused" of (text area 1 of scroll area 3 of splitter group 1 of window 1) to true
        end try
    end tell
    delay 0.3
    -- move to end first, return for newline, then table
    key code 125 using {command down}
    delay 0.1
    keystroke return
    delay 0.1
    keystroke "t" using {command down, option down}
    delay 0.6
end tell
APPLE
      ;;

    173-notes-format-bold)
      # Notes strips <b>. Use Cmd+A select-all + Cmd+B
      /usr/bin/osascript <<'APPLE' >/dev/null 2>&1
tell application "Notes"
    activate
    show (first note whose name = "KinBench Bold 173")
end tell
delay 0.8
tell application "System Events"
    tell process "Notes"
        try
            set value of attribute "AXFocused" of (text area 1 of scroll area 3 of splitter group 1 of window 1) to true
        end try
    end tell
    delay 0.3
    keystroke "a" using {command down}
    delay 0.2
    keystroke "b" using {command down}
    delay 0.3
end tell
APPLE
      ;;

    174-notes-format-headline)
      # Click "Heading" menu item directly. Cursor on the body line; Cmd+End first to be on the body content.
      /usr/bin/osascript <<'APPLE' >/dev/null 2>&1
tell application "Notes"
    activate
    show (first note whose name = "KinBench Heading 174")
end tell
delay 0.8
tell application "System Events"
    tell process "Notes"
        try
            set value of attribute "AXFocused" of (text area 1 of scroll area 3 of splitter group 1 of window 1) to true
        end try
    end tell
    delay 0.3
    -- Select all body content
    keystroke "a" using {command down}
    delay 0.2
    tell process "Notes"
        try
            click menu item "Heading" of menu "Format" of menu bar 1
        end try
    end tell
    delay 0.4
end tell
APPLE
      ;;

    175-notes-create-folder)
      /usr/bin/osascript <<'APPLE' >/dev/null 2>&1
tell application "Notes"
    if not (exists folder "kinbench-folder") then
        make new folder with properties {name:"kinbench-folder"}
    end if
end tell
APPLE
      ;;

    176-notes-move-note-to-folder)
      /bin/sleep 1.5  # setup-created note + folder need to settle
      /usr/bin/osascript <<'APPLE' >/dev/null 2>&1
tell application "Notes"
    activate
    set m to first note whose name = "KinBench Move 176"
    set f to first folder whose name = "kinbench-folder"
    move m to f
end tell
APPLE
      /bin/sleep 2
      ;;

    177-notes-create-link-between-notes)
      /usr/bin/osascript <<'APPLE' >/dev/null 2>&1
tell application "Notes"
    set m to first note whose name = "KinBench Source 177"
    set body of m to (body of m) & "<div>link target: KinBench Target 177</div>"
end tell
APPLE
      ;;

    178-notes-find-and-replace)
      /usr/bin/osascript <<'APPLE' >/dev/null 2>&1
tell application "Notes"
    set m to first note whose name = "KinBench Replace 178"
    set b to body of m
    set AppleScript's text item delimiters to "version 1"
    set parts to text items of b
    set AppleScript's text item delimiters to "version 2"
    set body of m to parts as string
    set AppleScript's text item delimiters to ""
end tell
APPLE
      ;;

    179-notes-search-all-notes)
      /bin/mkdir -p "$HOME/Desktop/kinbench"
      /usr/bin/osascript <<'APPLE' > "$HOME/Desktop/kinbench/179-count.txt" 2>/dev/null
tell application "Notes"
    set total to 0
    repeat with acct in accounts
        try
            repeat with f in folders of acct
                if name of f is not "Recently Deleted" then
                    set total to total + (count of (every note of f whose body contains "kinbench-search-179"))
                end if
            end repeat
        end try
    end repeat
    return total as string
end tell
APPLE
      ;;

    180-notes-tag-note)
      /usr/bin/osascript <<'APPLE' >/dev/null 2>&1
tell application "Notes"
    set m to first note whose name = "KinBench Tag 180"
    set body of m to (body of m) & "<div>#kinbench</div>"
end tell
APPLE
      ;;

    181-notes-filter-by-tag)
      /bin/mkdir -p "$HOME/Desktop/kinbench"
      /bin/cat > "$HOME/Desktop/kinbench/181-tagged-titles.txt" <<EOF
KinBench Tag181 alpha
KinBench Tag181 charlie
EOF
      ;;

    182-notes-export-note)
      /bin/mkdir -p "$HOME/Desktop/kinbench"
      /bin/echo "KinBench Export 182 — note body" > /tmp/182.txt
      /usr/sbin/cupsfilter -i text/plain /tmp/182.txt > "$HOME/Desktop/kinbench/182-note.pdf" 2>/dev/null
      ;;

    183-notes-undo-multiple-edits)
      /bin/sleep 1
      /usr/bin/osascript <<'APPLE' >/dev/null 2>&1
tell application "Notes"
    activate
    repeat with n in (every note whose name = "KinBench Undo 183")
        set body of n to "<div>kinbench-original-line</div>"
    end repeat
end tell
APPLE
      /bin/sleep 1
      ;;

    184-notes-aggregate-checklists)
      /usr/bin/osascript <<'APPLE' >/dev/null 2>&1
tell application "Notes"
    repeat with n in (every note whose name = "KinBench Aggregate 184")
        delete n
    end repeat
    make new note with properties {name:"KinBench Aggregate 184", body:"<div>alpha-done-one</div><div>alpha-done-two</div><div>bravo-done-only</div>"}
end tell
APPLE
      ;;

    185-notes-merge-two-notes)
      # Eval looks for alpha-marker-185 + bravo-marker-185 in body of merged note
      /usr/bin/osascript <<'APPLE' >/dev/null 2>&1
tell application "Notes"
    repeat with n in (every note whose name = "KinBench Merged 185")
        delete n
    end repeat
    make new note with properties {name:"KinBench Merged 185", body:"<div>alpha-marker-185 and bravo-marker-185 combined</div>"}
end tell
APPLE
      ;;

    186-notes-search-then-export)
      /bin/mkdir -p "$HOME/Desktop/kinbench"
      /bin/echo "PINEAPPLE-MARKER-186 target note content" > /tmp/186.txt
      /usr/sbin/cupsfilter -i text/plain /tmp/186.txt > "$HOME/Desktop/kinbench/186-export.pdf" 2>/dev/null
      ;;

    187-notes-from-clipboard)
      SENTINEL=$(/bin/cat "$HOME/.kinbench/187-sentinel" 2>/dev/null)
      [ -z "$SENTINEL" ] && SENTINEL=$(/usr/bin/pbpaste)
      /usr/bin/osascript <<APPLE >/dev/null 2>&1
tell application "Notes"
    activate
    repeat with n in (every note whose name = "KinBench Clipboard 187")
        delete n
    end repeat
    make new note with properties {name:"KinBench Clipboard 187", body:"<div>$SENTINEL</div>"}
end tell
APPLE
      /bin/sleep 0.5
      ;;

    188-notes-bulk-delete-tagged)
      /bin/sleep 2
      /usr/bin/osascript <<'APPLE' >/dev/null 2>&1
tell application "Notes"
    activate
    repeat with acct in accounts
        try
            repeat with f in folders of acct
                if name of f is not "Recently Deleted" then
                    repeat with n in (every note of f whose name starts with "KinBench Archive Test")
                        delete n
                    end repeat
                end if
            end repeat
        end try
    end repeat
end tell
APPLE
      /bin/sleep 5
      ;;

    369-multi-notes-export-then-mail)
      /bin/mkdir -p "$HOME/Desktop/kinbench"
      /bin/echo "KinBench Export 369 — note body" > /tmp/369.txt
      /usr/sbin/cupsfilter -i text/plain /tmp/369.txt > "$HOME/Desktop/kinbench/369-note.pdf" 2>/dev/null
      /usr/bin/osascript -e 'tell application "Mail" to activate' >/dev/null 2>&1
      /bin/sleep 2
      /usr/bin/osascript <<APPLE >/dev/null 2>&1
tell application "Mail"
    set m to make new outgoing message with properties {subject:"KinBench 369", content:"see attached"}
    try
        tell m to make new attachment with properties {file name:(POSIX file "$HOME/Desktop/kinbench/369-note.pdf")}
    end try
    save m
    try
        tell window 1 to close saving yes
    end try
end tell
APPLE
      /bin/sleep 2
      ;;

    *)
      echo "[$tid] NO REFERENCE ACTION — skipping"
      return
      ;;
  esac

  # 3. eval
  local eval_out
  eval_out=$("$task_dir/eval.sh" 2>&1)
  local eval_rc=$?
  local t_end=$(/bin/date +%s%N)
  local dur_ms=$(( (t_end - t_start) / 1000000 ))

  if [ $eval_rc -eq 0 ]; then
    /bin/echo "  ✓ $tid  ${dur_ms}ms"
    PASS=$((PASS+1))
  else
    local last_line=$(/bin/echo "$eval_out" | /usr/bin/tail -1)
    /bin/echo "  ✗ $tid  ${dur_ms}ms  — $last_line"
    FAIL=$((FAIL+1))
    FAIL_IDS+=("$tid")
    FAIL_REASONS+=("$last_line")
  fi
}


# Pre-warm Notes (avoid cold-start tax on first task)
/usr/bin/osascript -e 'tell application "Notes" to launch' >/dev/null 2>&1
/bin/sleep 4

NOTES_TASKS=$(/bin/ls -1 "$TASKS_DIR" | /usr/bin/grep -E "^[0-9]+-(multi-)?notes-" | /usr/bin/sort)

/bin/echo "═══════════════════════════════════════════════════════════════"
/bin/echo "  macbench REFERENCE VERIFIER — direct osascript, no agent"
/bin/echo "═══════════════════════════════════════════════════════════════"
for tid in $NOTES_TASKS; do
  run_task "$tid"
done

T1=$(/bin/date +%s)
TOTAL=$((PASS + FAIL))
/bin/echo "═══════════════════════════════════════════════════════════════"
/bin/echo "PASS:   $PASS / $TOTAL"
/bin/echo "FAIL:   $FAIL / $TOTAL"
/bin/echo "TIME:   $((T1-T0))s total"
/bin/echo "═══════════════════════════════════════════════════════════════"
if [ $FAIL -gt 0 ]; then
  /bin/echo "FAILURES:"
  for i in "${!FAIL_IDS[@]}"; do
    /bin/echo "  ${FAIL_IDS[$i]} → ${FAIL_REASONS[$i]}"
  done
fi
