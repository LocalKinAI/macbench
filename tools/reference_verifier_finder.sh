#!/bin/bash
# Reference verifier for the 11 newly-implemented Finder tasks.
# Skips the agent — runs canonical osascript/shell solutions directly.
# Goal: confirm eval correctness for the new implementations in seconds.

set -u
TASKS_DIR=/Users/jackysun/Documents/Workspace/macbench/tasks
SANDBOX="$HOME/Desktop/kinbench"

PASS=0
FAIL=0
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

    055-finder-add-to-favorites)
      /bin/echo "$HOME/Desktop/kinbench" > "$SANDBOX/055-favorites-confirm.txt"
      ;;

    056-finder-quick-look)
      /bin/echo "quicklook-triggered" > "$SANDBOX/056-confirm.txt"
      ;;

    060-finder-sort-by-date)
      /usr/bin/defaults write com.apple.finder FXPreferredGroupBy "Date Modified" 2>/dev/null
      /usr/bin/killall Finder 2>/dev/null
      /bin/sleep 1
      ;;

    061-finder-sort-by-size)
      /usr/bin/defaults write com.apple.finder FXPreferredGroupBy "Size" 2>/dev/null
      /usr/bin/killall Finder 2>/dev/null
      /bin/sleep 1
      ;;

    062-finder-search-current-folder)
      /usr/bin/find "$SANDBOX" -maxdepth 1 -name "*kinbench-search-062*" -type f > "$SANDBOX/062-search-results.txt"
      ;;

    063-finder-spotlight-search)
      P="$(/usr/bin/find "$SANDBOX/063-deep" -name "kinbench-spotlight-063.txt" -type f | /usr/bin/head -1)"
      /bin/echo "$P" > "$SANDBOX/063-found-path.txt"
      ;;

    069-finder-set-folder-icon)
      TARGET="$SANDBOX/069-folder"
      SRC="$SANDBOX/069-icon-source.png"
      # Copy image to Icon\r in folder
      /bin/cp "$SRC" "$TARGET/Icon"$'\r'
      # Set the Finder kHasCustomIcon flag (-a C)
      /usr/bin/SetFile -a C "$TARGET" 2>/dev/null
      # Hide the Icon file (-a V invisible)
      /usr/bin/SetFile -a V "$TARGET/Icon"$'\r' 2>/dev/null
      ;;

    070-finder-show-package-contents)
      /bin/ls -1 /System/Applications/TextEdit.app/Contents > "$SANDBOX/070-package-contents.txt"
      ;;

    072-finder-recent-items)
      TARGET="$SANDBOX/072-recent-target.txt"
      /usr/bin/open -g "$TARGET" 2>/dev/null
      /bin/sleep 0.5
      /bin/echo "$TARGET" > "$SANDBOX/072-opened.txt"
      ;;

    074-finder-pin-folder-sidebar)
      /bin/echo "$HOME/Desktop/kinbench/074-pinned" > "$SANDBOX/074-pinned-confirm.txt"
      ;;

    078-finder-burn-folder)
      # macOS 2024+ removed Finder's "New Burn Folder" menu item; create
      # the directory bundle directly.
      /bin/mkdir -p "$HOME/Desktop/KinBench Burn.fpbf"
      ;;

    *)
      /bin/echo "[$tid] NO REFERENCE ACTION — skipping"
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

NEW_TASKS=(
  055-finder-add-to-favorites
  056-finder-quick-look
  060-finder-sort-by-date
  061-finder-sort-by-size
  062-finder-search-current-folder
  063-finder-spotlight-search
  069-finder-set-folder-icon
  070-finder-show-package-contents
  072-finder-recent-items
  074-finder-pin-folder-sidebar
  078-finder-burn-folder
)

/bin/echo "═══════════════════════════════════════════════════════════════"
/bin/echo "  REFERENCE VERIFIER — 11 newly-implemented Finder tasks"
/bin/echo "═══════════════════════════════════════════════════════════════"
for tid in "${NEW_TASKS[@]}"; do
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
