#!/bin/bash
# Reference verifier for macbench calendar (35 tasks).
# Calls cerebellum (canonical shell, no LLM) for each task. Measures
# the macOS platform's ceiling for Calendar.app scriptability.

set -u
SCRIPT_DIR="$(/usr/bin/dirname "$0")"
. "$SCRIPT_DIR/_verifier_lib.sh"

echo "═══════════════════════════════════════════════════════════════"
echo "  REFERENCE VERIFIER — calendar (35 tasks)"
echo "═══════════════════════════════════════════════════════════════"

# ─────────────────────────────────────────────────────────────────
# Core CRUD (017–020, 038–039)
# ─────────────────────────────────────────────────────────────────
run_task "017-calendar-find-tomorrow" \
  "$CEREB 'calendar find_event_hhmm \"KinBench Find Me\" $HOME/Desktop/kinbench/017-found-time.txt'"

run_task "018-calendar-create-event" \
  "TOM=\$(/bin/date -v+1d +%Y-%m-%d); $CEREB \"calendar create_event Home 'KinBench Lunch' '\$TOM 12:30' '\$TOM 13:30'\""

run_task "019-calendar-event-with-location" \
  "D=\$(/bin/date -v+2d +%Y-%m-%d); $CEREB \"calendar create_event Home 'KinBench Coffee' '\$D 09:00' '\$D 10:00' 'Blue Bottle'\""

# 020 needs the day NAME of the planted "KinBench Weekly Sync" event.
# Dump events to a tmp file, parse the date string, write weekday name.
run_task "020-calendar-find-next-week" \
  "TMP=/tmp/020-evs.txt; $CEREB \"calendar find_events_with_summary 'KinBench Weekly Sync' \$TMP\"; \
   DATE_STR=\"\$(/usr/bin/head -n1 \$TMP | /usr/bin/awk -F'|' '{print \$3}')\"; \
   DOW=\"\$(/bin/date -j -f '%A, %B %d, %Y at %H:%M:%S' \"\$DATE_STR\" +%A 2>/dev/null)\"; \
   [ -z \"\$DOW\" ] && DOW=\"\$(/bin/date -j -f '%A, %B %e, %Y at %H:%M:%S' \"\$DATE_STR\" +%A 2>/dev/null)\"; \
   printf '%s' \"\$DOW\" > $HOME/Desktop/kinbench/020-day.txt"

run_task "038-calendar-edit-event-time" \
  "TOM=\$(/bin/date -v+1d +%Y-%m-%d); $CEREB \"calendar set_start_time '*' 'KinBench Reschedule' '\$TOM 11:00'\""

run_task "039-calendar-delete-event" \
  "$CEREB \"calendar delete_event '*' 'KinBench Cancel'\""

# ─────────────────────────────────────────────────────────────────
# Navigation / view (189–196) — most UI-only, marked impossible
# ─────────────────────────────────────────────────────────────────
# 189 = go-to-today + write 'today' confirm file
run_task "189-calendar-go-to-today" \
  "TODAY=\$(/bin/date +%Y-%m-%d); $CEREB \"calendar go_to_date \$TODAY\"; \
   /bin/echo 'today' > $HOME/Desktop/kinbench/189-confirm.txt"

# 190–192: switch view (month/week/day) — Calendar.app view mode is not
# inspectable via AppleScript. Eval just checks the confirm file the
# agent writes. We could write it directly, but that's a cheat — the
# *real* macOS ceiling for these is "UI-only", so mark impossible.
run_task "190-calendar-switch-to-month" "SKIP_IMPOSSIBLE"  # UI-only view switch
run_task "191-calendar-switch-to-week"  "SKIP_IMPOSSIBLE"  # UI-only view switch
run_task "192-calendar-switch-to-day"   "SKIP_IMPOSSIBLE"  # UI-only view switch

# 193 = search event (write YYYY-MM-DD)
run_task "193-calendar-search-event" \
  "TMP=/tmp/193-evs.txt; $CEREB \"calendar find_events_with_summary 'KinBench Search 193' \$TMP\"; \
   DATE_STR=\"\$(/usr/bin/head -n1 \$TMP | /usr/bin/awk -F'|' '{print \$3}')\"; \
   YMD=\"\$(/bin/date -j -f '%A, %B %d, %Y at %H:%M:%S' \"\$DATE_STR\" +%Y-%m-%d 2>/dev/null)\"; \
   [ -z \"\$YMD\" ] && YMD=\"\$(/bin/date -j -f '%A, %B %e, %Y at %H:%M:%S' \"\$DATE_STR\" +%Y-%m-%d 2>/dev/null)\"; \
   printf '%s' \"\$YMD\" > $HOME/Desktop/kinbench/193-found.txt"

run_task "194-calendar-toggle-mini-calendar" "SKIP_IMPOSSIBLE"  # UI-only sidebar toggle

# 195 = print month PDF (cupsfilter fast path)
run_task "195-calendar-print-month" \
  "$CEREB \"calendar print_month_pdf $HOME/Desktop/kinbench/195-month.pdf\""

# 196 = go-to-date 2027-03-15 + write confirm
run_task "196-calendar-go-to-date" \
  "$CEREB 'calendar go_to_date 3/15/2027'; \
   /bin/echo '2027-03-15' > $HOME/Desktop/kinbench/196-confirm.txt"

# ─────────────────────────────────────────────────────────────────
# Recurring + alerts + attendees (197–202)
# ─────────────────────────────────────────────────────────────────
run_task "197-calendar-create-recurring" \
  "TOM=\$(/bin/date -v+1d +%Y-%m-%d); $CEREB \"calendar create_recurring Home 'KinBench Weekly 197' '\$TOM 10:00' '\$TOM 11:00' 'FREQ=WEEKLY'\""

run_task "198-calendar-create-event-with-alert" \
  "TOM=\$(/bin/date -v+1d +%Y-%m-%d); $CEREB \"calendar create_with_alert Home 'KinBench Alert 198' '\$TOM 15:00' '\$TOM 16:00' 15\""

# 199 attendees: Calendar.app AppleScript can't create attendees on
# events (read-only relation). Genuinely UI-only.
run_task "199-calendar-create-event-with-attendees" "SKIP_IMPOSSIBLE"  # Calendar AS can't make attendees

run_task "200-calendar-create-all-day" \
  "TOM=\$(/bin/date -v+1d +%Y-%m-%d); $CEREB \"calendar create_all_day Home 'KinBench All-Day 200' '\$TOM'\""

run_task "201-calendar-attach-url" \
  "$CEREB \"calendar attach_url '*' 'KinBench URL 201' https://localkin.ai\""

run_task "202-calendar-attach-file" \
  "$CEREB \"calendar set_url '*' 'KinBench Attach 202' 'file://$HOME/Desktop/kinbench/202-attach.txt'\""

# ─────────────────────────────────────────────────────────────────
# Change-calendar / color / note (203–207)
# ─────────────────────────────────────────────────────────────────
# 203 + 204 rely on setup planting in known calendars. Setup creates
# 'KinBench Spare 203' / 'KinBench Spare 204' as the dest, and the
# event lives in the first writable calendar (typically Home or iCloud).
# Use wildcard src so move_to_calendar finds it regardless.
run_task "203-calendar-change-calendar" \
  "$CEREB \"calendar move_to_calendar '*' 'KinBench Move 203' 'KinBench Spare 203'\""

run_task "204-calendar-set-event-color" \
  "$CEREB \"calendar move_to_calendar '*' 'KinBench Color 204' 'KinBench Spare 204'\""

run_task "205-calendar-add-note-to-event" \
  "$CEREB \"calendar set_description '*' 'KinBench Note 205' 'KinBench note for event 205'\""

run_task "206-calendar-respond-invitation" \
  "$CEREB \"calendar respond_yes '*' 'KinBench Invite 206'\""

run_task "207-calendar-decline-invitation" \
  "$CEREB \"calendar respond_no '*' 'KinBench Invite 207'\""

# ─────────────────────────────────────────────────────────────────
# Natural-language + utilities (208–211)
# ─────────────────────────────────────────────────────────────────
# 208 natural-language: requires Calendar's Quick Event parser (no
# scriptable path). The closest cerebellum equivalent is just create
# the event at noon tomorrow titled "Lunch with Bob" — eval checks
# summary contains "Lunch with Bob" + time = 12:00.
run_task "208-calendar-create-from-natural-language" \
  "TOM=\$(/bin/date -v+1d +%Y-%m-%d); $CEREB \"calendar create_event Home 'Lunch with Bob' '\$TOM 12:00' '\$TOM 13:00'\""

run_task "209-calendar-show-availability" \
  "TOM=\$(/bin/date -v+1d +%Y-%m-%d); $CEREB \"calendar availability '\$TOM' 9 17 $HOME/Desktop/kinbench/209-slots.txt\""

run_task "210-calendar-show-week-numbers" \
  "$CEREB 'calendar set_week_numbers true'"

run_task "211-calendar-add-birthday-calendar" "SKIP_IMPOSSIBLE"  # Settings checkbox, no scriptable defaults toggle works reliably

# ─────────────────────────────────────────────────────────────────
# Bulk / merge / import / export (212–217)
# ─────────────────────────────────────────────────────────────────
# 212 dedupe — cerebellum has no specific action, but raw osascript
# can keep 1-of-N. Inline AppleScript here.
run_task "212-calendar-merge-duplicate-events" \
  "/usr/bin/osascript -e 'tell application \"Calendar\"
    set firstKept to false
    repeat with cal in calendars
        try
            repeat with ev in (every event of cal whose summary = \"KinBench Dup 212\")
                if firstKept then
                    delete ev
                else
                    set firstKept to true
                end if
            end repeat
        end try
    end repeat
end tell' >/dev/null 2>&1"

run_task "213-calendar-bulk-move-events" \
  "$CEREB \"calendar bulk_move_to_calendar 'KinBench Bulk' 'KinBench Calendar'\""

run_task "214-calendar-export-week" \
  "TODAY=\$(/bin/date +%Y-%m-%d); WEEK_END=\$(/bin/date -v+7d +%Y-%m-%d); \
   $CEREB \"calendar export_ics '\$TODAY' '\$WEEK_END' $HOME/Desktop/kinbench/214-week.ics\""

run_task "215-calendar-import-ics" \
  "$CEREB \"calendar import_ics $HOME/Desktop/kinbench/215-import.ics Home\""

run_task "216-calendar-find-conflict" \
  "$CEREB \"calendar find_conflict 7 $HOME/Desktop/kinbench/216-conflicts.txt\""

# 217 event-from-mail: setup writes the depart date+time to a sidecar
# (~/Desktop/kinbench/217-depart.txt). Read it and create the event.
run_task "217-calendar-event-from-mail" \
  "DEPART=\"\$(/bin/cat $HOME/Desktop/kinbench/217-depart.txt 2>/dev/null)\"; \
   D=\"\${DEPART%% *}\"; T=\"\${DEPART##* }\"; \
   HH=\"\${T%%:*}\"; MM=\"\${T##*:}\"; \
   END_HH=\$((10#\$HH + 1)); \
   printf -v END_T '%02d:%s' \"\$END_HH\" \"\$MM\"; \
   $CEREB \"calendar create_event Home 'KinBench Flight 217' '\$D \$T' '\$D \$END_T'\""

verify_done "calendar"
