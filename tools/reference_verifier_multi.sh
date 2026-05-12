#!/bin/bash
# Reference verifier for macbench multi-app (14 tasks).
# Each task crosses two+ apps; cerebellum's `multi` dispatcher composes
# the canonical action sequence.

set -u
SCRIPT_DIR="$(/usr/bin/dirname "$0")"
. "$SCRIPT_DIR/_verifier_lib.sh"

echo "═══════════════════════════════════════════════════════════════"
echo "  REFERENCE VERIFIER — multi-app (14 tasks)"
echo "═══════════════════════════════════════════════════════════════"

# 029: screenshot → Mail draft
run_task "029-multi-screenshot-to-mail" \
  "$CEREB \"multi screenshot_to_mail 'KinBench 029 Screenshot' '' $HOME/Desktop/kinbench/029-shot.png\""

# 030: find calendar event → make a Reminder of same title
run_task "030-multi-event-to-reminder" \
  "$CEREB \"multi event_to_reminder 'KinBench Source Event' Reminders\""

# 048: Finder → Mail attachment
run_task "048-multi-finder-mail-attach" \
  "$CEREB \"multi finder_mail_attach $HOME/Desktop/kinbench/048-attach.txt 'KinBench 048'\""

# 049: Spotlight-launched Calendar + create event
run_task "049-multi-spotlight-calendar" \
  "TOM=\$(/bin/date -v+1d +%Y-%m-%d); $CEREB \"multi spotlight_calendar 'KinBench Spotlight Path' '\$TOM 15:00' '\$TOM 16:00'\""

# 050: Pages doc body + export PDF
run_task "050-multi-pages-pdf" \
  "$CEREB \"multi pages_text_pdf 'kinbench 050 export' $HOME/Desktop/kinbench/050-doc.pdf\""

# 361: camera JPEG → Mail draft attached (composite falls back to screencapture)
run_task "361-multi-photo-from-camera-to-mail" \
  "$CEREB \"multi photo_camera_to_mail $HOME/Desktop/kinbench/361-photo.jpg 'KinBench 361'\""

# 362: search Mail + create calendar event (setup plants 'Flight KinBench 362' depart 2026-06-15 14:30)
run_task "362-multi-search-then-calendar" \
  "$CEREB \"multi search_mail_then_calendar flight Home 'KinBench Flight 362' '2026-06-15 14:30' '2026-06-15 15:30'\""

# 363: Safari → clipboard → Note. Cerebellum's clipboard_to_note assumes
# the agent already copied to clipboard; we simulate by stuffing a known
# paragraph into the pasteboard before invoking, so the composite picks
# it up and creates the note.
run_task "363-multi-clipboard-then-note" \
  "/bin/echo 'macOS (formerly OS X) is a Unix operating system developed by Apple.' | /usr/bin/pbcopy; \
   $CEREB \"multi clipboard_to_note 'KinBench Clipboard 363'\""

# 364: screenshot → Pages doc
run_task "364-multi-screenshot-then-pages" \
  "$CEREB \"multi screenshot_to_pages $HOME/Desktop/kinbench/364-doc.pages $HOME/Desktop/kinbench/364-shot.png\""

# 365: Music pause + screenshot
run_task "365-multi-music-pause-then-screenshot" \
  "$CEREB \"multi music_pause_then_screenshot $HOME/Desktop/kinbench/365-shot.png\""

# 366: Finder reveal → Quick Look (Preview) → screenshot
run_task "366-multi-finder-then-quicklook" \
  "$CEREB \"multi finder_quicklook $HOME/Desktop/kinbench/366-doc.pdf $HOME/Desktop/kinbench/366-shot.png\""

# 367: Spotlight contact → Mail draft (setup plants 'KinBench Apple 367')
run_task "367-multi-spotlight-then-mail" \
  "$CEREB \"multi contact_to_mail 'KinBench Apple 367' 'KinBench 367' 'spotlight-resolved contact email'\""

# 368: Reminders → Calendar events at SAME times as the reminders
# (morning=9:00, noon=12:00, evening=17:00, 30-min each). The generic
# reminders_to_calendar stacks them, which won't match the spec; emit
# three explicit create_event calls instead.
run_task "368-multi-reminders-then-calendar" \
  "TOM=\$(/bin/date -v+1d +%Y-%m-%d); \
   $CEREB \"calendar create_event Home 'KinBench 368 morning' '\$TOM 09:00' '\$TOM 09:30'\"; \
   $CEREB \"calendar create_event Home 'KinBench 368 noon'    '\$TOM 12:00' '\$TOM 12:30'\"; \
   $CEREB \"calendar create_event Home 'KinBench 368 evening' '\$TOM 17:00' '\$TOM 17:30'\""

# 369: Notes export PDF → Mail draft attached
run_task "369-multi-notes-export-then-mail" \
  "$CEREB \"multi note_to_mail 'KinBench Export 369' 'KinBench 369' '' $HOME/Desktop/kinbench/369-note.pdf\""

verify_done "multi-app"
