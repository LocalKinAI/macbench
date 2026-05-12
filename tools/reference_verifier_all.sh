#!/bin/bash
# Master reference verifier — runs every category's verifier in sequence
# and aggregates results into a single platform-ceiling number.
#
# Each per-category verifier runs setup → cerebellum-canonical-action → eval
# WITHOUT any LLM in the loop. The pass-rate is the "what's achievable on
# this macOS, with shell + AppleScript + cerebellum's wrappers" — the
# theoretical upper bound for any LLM agent on macbench.
#
# Categories included: finder (50 — using _finder_all variant covering
# all 50 not just the 11-subset), notes (31 — legacy inline), and 13
# new lib-based verifiers covering settings/mail/safari/calendar/
# reminders/terminal/music/photos/maps/pages/numbers/keynote/multi.

set -u
SCRIPT_DIR="$(/usr/bin/dirname "$0")"
T0=$(/bin/date +%s)

GRAND_PASS=0
GRAND_FAIL=0
GRAND_SKIP=0
GRAND_TIME=0

# Per-category log files for after-the-fact inspection
LOG_DIR=/tmp/macbench-reference-logs
/bin/rm -rf "$LOG_DIR"
/bin/mkdir -p "$LOG_DIR"

run_verifier() {
  local script="$1"
  local label="$2"
  local logfile="$LOG_DIR/${label}.log"
  local t_start
  t_start=$(/bin/date +%s)

  echo ""
  echo "▶▶▶ $label …"
  if [ ! -x "$script" ]; then
    echo "  ⚠ $script not executable — skipping"
    return
  fi
  "$script" > "$logfile" 2>&1
  local rc=$?
  local t_end
  t_end=$(/bin/date +%s)
  local elapsed=$((t_end - t_start))

  # Parse the summary from the bottom of the log
  local pass fail skip
  pass=$(/usr/bin/grep -E "^\s+PASS:" "$logfile" | /usr/bin/tail -1 | /usr/bin/awk '{print $2}')
  fail=$(/usr/bin/grep -E "^\s+FAIL:" "$logfile" | /usr/bin/tail -1 | /usr/bin/awk '{print $2}')
  skip=$(/usr/bin/grep -E "^\s+SKIP:" "$logfile" | /usr/bin/tail -1 | /usr/bin/awk '{print $2}')
  [ -z "$pass" ] && pass=0
  [ -z "$fail" ] && fail=0
  [ -z "$skip" ] && skip=0

  printf "  %-12s PASS=%3s FAIL=%3s SKIP=%3s   time=%ds (rc=%d)\n" \
    "$label" "$pass" "$fail" "$skip" "$elapsed" "$rc"

  GRAND_PASS=$((GRAND_PASS + pass))
  GRAND_FAIL=$((GRAND_FAIL + fail))
  GRAND_SKIP=$((GRAND_SKIP + skip))
  GRAND_TIME=$((GRAND_TIME + elapsed))
}

# Order categories by expected speed (fast ones first so progress is visible)
run_verifier "$SCRIPT_DIR/reference_verifier_finder_all.sh" finder
run_verifier "$SCRIPT_DIR/reference_verifier_terminal.sh"   terminal
run_verifier "$SCRIPT_DIR/reference_verifier_maps.sh"       maps
run_verifier "$SCRIPT_DIR/reference_verifier_music.sh"      music
run_verifier "$SCRIPT_DIR/reference_verifier_photos.sh"     photos
run_verifier "$SCRIPT_DIR/reference_verifier_keynote.sh"    keynote
run_verifier "$SCRIPT_DIR/reference_verifier_settings.sh"   settings
run_verifier "$SCRIPT_DIR/reference_verifier_pages.sh"      pages
run_verifier "$SCRIPT_DIR/reference_verifier_numbers.sh"    numbers
run_verifier "$SCRIPT_DIR/reference_verifier_reminders.sh"  reminders
run_verifier "$SCRIPT_DIR/reference_verifier_safari.sh"     safari
run_verifier "$SCRIPT_DIR/reference_verifier_mail.sh"       mail
run_verifier "$SCRIPT_DIR/reference_verifier_calendar.sh"   calendar
run_verifier "$SCRIPT_DIR/reference_verifier_multi.sh"      multi
run_verifier "$SCRIPT_DIR/reference_verifier.sh"            notes

GRAND_TOTAL=$((GRAND_PASS + GRAND_FAIL + GRAND_SKIP))
TOTAL_ELAPSED=$(( $(/bin/date +%s) - T0 ))

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "  REFERENCE VERIFIER — PLATFORM CEILING (369 tasks)"
echo "═══════════════════════════════════════════════════════════════"
printf "  PASS:  %3d / %d (%d%%)\n" "$GRAND_PASS" "$GRAND_TOTAL" "$((GRAND_PASS * 100 / (GRAND_TOTAL == 0 ? 1 : GRAND_TOTAL)))"
printf "  FAIL:  %3d / %d (%d%%)\n" "$GRAND_FAIL" "$GRAND_TOTAL" "$((GRAND_FAIL * 100 / (GRAND_TOTAL == 0 ? 1 : GRAND_TOTAL)))"
printf "  SKIP:  %3d / %d (%d%%) — UI-only / TCC-locked\n" "$GRAND_SKIP" "$GRAND_TOTAL" "$((GRAND_SKIP * 100 / (GRAND_TOTAL == 0 ? 1 : GRAND_TOTAL)))"
printf "  TIME:  %ds (≈ %.1f min)   AVG: %.2fs / task\n" \
  "$TOTAL_ELAPSED" "$(echo "scale=1; $TOTAL_ELAPSED / 60" | /usr/bin/bc 2>/dev/null || echo n/a)" \
  "$(echo "scale=2; $TOTAL_ELAPSED / $GRAND_TOTAL" | /usr/bin/bc 2>/dev/null || echo n/a)"
echo "═══════════════════════════════════════════════════════════════"
echo "  Per-category logs in: $LOG_DIR"
echo "═══════════════════════════════════════════════════════════════"
