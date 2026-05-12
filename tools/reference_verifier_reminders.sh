#!/bin/bash
# Reference verifier for macbench reminders.
# Calls cerebellum (canonical shell, no LLM) for each task.
# Measures the macOS platform's ceiling — what's achievable via
# AppleScript / shell with no model in the loop.

set -u
SCRIPT_DIR="$(/usr/bin/dirname "$0")"
. "$SCRIPT_DIR/_verifier_lib.sh"

KINBENCH_DIR="$HOME/Desktop/kinbench"
/bin/mkdir -p "$KINBENCH_DIR"

# Tomorrow at 17:00 — for task 047.
TOMORROW="$(/bin/date -v+1d +%Y-%m-%d)"

echo "═══════════════════════════════════════════════════════════════"
echo "  REFERENCE VERIFIER — reminders (25 tasks)"
echo "═══════════════════════════════════════════════════════════════"

# 045 — create plain reminder in default 'Reminders' list.
run_task "045-reminders-create" "$CEREB 'reminders create Reminders \"KinBench Buy Milk\"'"

# 046 — complete an existing reminder.
run_task "046-reminders-complete" "$CEREB 'reminders complete Reminders \"KinBench Mark Done\"'"

# 047 — set due date to tomorrow at 17:00.
run_task "047-reminders-due-date" "$CEREB 'reminders set_due Reminders \"KinBench Schedule\" \"$TOMORROW 17:00\"'"

# 218 — create with named list (auto-creates the list).
run_task "218-reminders-create-with-list" "$CEREB 'reminders create kinbench-list-218 \"KinBench List Item 218\"'"

# 219 — set priority high.
run_task "219-reminders-add-priority" "$CEREB 'reminders set_priority Reminders \"KinBench Priority 219\" high'"

# 220 — flag a reminder (wildcard list).
run_task "220-reminders-add-flag" "$CEREB 'reminders flag * \"KinBench Flag 220\"'"

# 221 — show Flagged smart list (sidebar = UI-only; soft-pass via marker).
run_task "221-reminders-show-flagged" "$CEREB 'reminders show_flagged $KINBENCH_DIR/221-flagged-confirm.txt'"

# 222 — show Today smart list (sidebar = UI-only; soft-pass via marker).
run_task "222-reminders-show-today" "$CEREB 'reminders show_today $KINBENCH_DIR/222-today-confirm.txt'"

# 223 — create a new list.
run_task "223-reminders-create-list" "$CEREB 'reminders create_list kinbench-list-223'"

# 224 — rename a list.
run_task "224-reminders-rename-list" "$CEREB 'reminders rename_list kinbench-rename-pre kinbench-rename-post'"

# 225 — delete a list.
run_task "225-reminders-delete-list" "$CEREB 'reminders delete_list kinbench-deleteme-225'"

# 226 — location reminder. AS can't set geofence; dispatcher stores a
# body marker. The eval accepts the marker form.
run_task "226-reminders-create-with-location" "$CEREB 'reminders create Reminders \"KinBench Location 226\"' && $CEREB 'reminders set_location * \"KinBench Location 226\" \"Apple Park, Cupertino\"'"

# 227 — add subtask (macOS 14+ flattens hierarchy; lenient eval).
run_task "227-reminders-add-subtask" "$CEREB 'reminders add_subtask \"KinBench Parent 227\" \"KinBench Subtask A 227\"'"

# 228 — complete a subtask.
run_task "228-reminders-mark-subtask" "$CEREB 'reminders complete Reminders \"KinBench Subtask 228\"'"

# 229 — add notes to a reminder body.
run_task "229-reminders-add-note" "$CEREB 'reminders set_body * \"KinBench Description 229\" \"KinBench Notes 229\"'"

# 230 — attach image (AS can't attach; body-marker soft-pass).
run_task "230-reminders-attach-image" "$CEREB 'reminders attach_image * \"KinBench Image 230\" $KINBENCH_DIR/230-img.jpg'"

# 231 — set recurring (AS doesn't expose RRULE; body-marker soft-pass).
run_task "231-reminders-set-recurring" "$CEREB 'reminders set_recurring * \"KinBench Recurring 231\" weekly'"

# 232 — add tag (Reminders hides tag prop on macOS 14+; body soft-pass).
run_task "232-reminders-add-tag" "$CEREB 'reminders add_tag * \"KinBench Tag 232\" kinbench'"

# 233 — filter by tag (sidebar/tag UI only; soft-pass via marker).
run_task "233-reminders-filter-by-tag" "$CEREB 'reminders filter_by_list Reminders $KINBENCH_DIR/233-tag-confirm.txt'"

# 234 — share list (share sheet is UI-only; soft-pass via marker).
run_task "234-reminders-share-list" "$CEREB 'reminders open_share kinbench-share-234 $KINBENCH_DIR/234-share-confirm.txt'"

# 235 — create reminders from mail-mock text file.
run_task "235-reminders-from-mail" "$CEREB 'reminders from_mail $KINBENCH_DIR/235-mail.txt kinbench-from-mail-235 \"Please \"'"

# 236 — cleanup all completed reminders across every list.
run_task "236-reminders-cleanup-completed" "$CEREB 'reminders cleanup_completed'"

# 237 — set high priority on every reminder due today.
run_task "237-reminders-bulk-priority" "$CEREB 'reminders bulk_priority_today high'"

# 238 — export every reminder in a list to a text file.
run_task "238-reminders-export-list" "$CEREB 'reminders export_list kinbench-export-238 $KINBENCH_DIR/238-list.txt'"

# 239 — import markdown checklist into a list.
run_task "239-reminders-import-from-file" "$CEREB 'reminders import_from_file kinbench-imported $KINBENCH_DIR/239-checklist.md'"

verify_done "reminders"
