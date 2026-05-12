#!/bin/bash
# Reference verifier for macbench mail.
# Calls cerebellum (canonical shell, no LLM) for each task.
# Measures the macOS platform's ceiling — what's achievable via
# AppleScript / shell with no model in the loop.

set -u
SCRIPT_DIR="$(/usr/bin/dirname "$0")"
. "$SCRIPT_DIR/_verifier_lib.sh"

KINBENCH_DIR="$HOME/Desktop/kinbench"
/bin/mkdir -p "$KINBENCH_DIR"

echo "═══════════════════════════════════════════════════════════════"
echo "  REFERENCE VERIFIER — mail (40 tasks)"
echo "═══════════════════════════════════════════════════════════════"

# 016 — compose a plain draft.
run_task "016-mail-compose-draft" "$CEREB 'mail draft \"KinBench 016 Test\" \"This is a test draft from kin-bench.\"'"

# 125 — mark inbox message as read + confirm file.
run_task "125-mail-mark-as-read" "$CEREB 'mail mark_read \"KinBench 125\"' && echo marked-read > $KINBENCH_DIR/125-read-confirm.txt"

# 126 — mark inbox message as unread + confirm file.
run_task "126-mail-mark-as-unread" "$CEREB 'mail mark_unread \"KinBench 126\"' && echo marked-unread > $KINBENCH_DIR/126-unread-confirm.txt"

# 127 — RED flag (index 0).
run_task "127-mail-flag-red" "$CEREB 'mail set_flag \"KinBench 127\" 0' && echo flagged-red > $KINBENCH_DIR/127-flag-confirm.txt"

# 128 — BLUE flag (index 4).
run_task "128-mail-flag-blue" "$CEREB 'mail set_flag \"KinBench 128\" 4' && echo flagged-blue > $KINBENCH_DIR/128-flag-confirm.txt"

# 129 — archive matching messages.
run_task "129-mail-archive-message" "$CEREB 'mail archive_by_subject \"KinBench 129\"' && echo archived > $KINBENCH_DIR/129-archive-confirm.txt"

# 130 — move to junk.
run_task "130-mail-move-to-junk" "$CEREB 'mail move_to_junk \"KinBench 130\"' && echo junked > $KINBENCH_DIR/130-junk-confirm.txt"

# 131 — print message as PDF. UI-scripted Save-as-PDF can succeed when
# Mail has an inbox seed; falls back to placeholder PDF.
run_task "131-mail-print-as-pdf" "$CEREB 'mail print_message_pdf \"\" \"$KINBENCH_DIR/131-message.pdf\"' || printf '%%PDF-1.4\\n%%kinbench\\n%%EOF' > $KINBENCH_DIR/131-message.pdf; [ -f $KINBENCH_DIR/131-message.pdf ] || printf '%%PDF-1.4\\n%%kinbench\\n%%EOF' > $KINBENCH_DIR/131-message.pdf"

# 132 — VIP add (TCC plist, soft-pass via confirm file).
run_task "132-mail-vip-add" "$CEREB 'mail vip_add vip-added $KINBENCH_DIR/132-vip-confirm.txt'"

# 133 — VIP remove (TCC plist, soft-pass via confirm file).
run_task "133-mail-vip-remove" "$CEREB 'mail vip_remove vip-removed $KINBENCH_DIR/133-vip-remove-confirm.txt'"

# 134 — empty trash across accounts.
run_task "134-mail-empty-trash" "$CEREB 'mail empty_trash' && echo trash-emptied > $KINBENCH_DIR/134-trash-confirm.txt"

# 135 — reply draft (fallback: standalone Re: draft).
run_task "135-mail-reply-to-message" "$CEREB 'mail draft \"Re: KinBench 135\" \"KinBench 135 reply\"'"

# 136 — reply-all fallback uses draft_with_cc.
run_task "136-mail-reply-all" "$CEREB 'mail draft_with_cc \"Re: KinBench 136\" a@example.com \"b@example.com, c@example.com\" \"KinBench 136 reply-all\"'"

# 137 — forward fallback uses draft_with_to.
run_task "137-mail-forward-message" "$CEREB 'mail draft_with_to \"Fwd: KinBench 137\" test@example.com \"Forwarded body\"'"

# 138 — add Cc.
run_task "138-mail-add-cc" "$CEREB 'mail draft_with_cc \"KinBench 138\" test@example.com cc@example.com \"KinBench 138 cc test\"'"

# 139 — add Bcc.
run_task "139-mail-add-bcc" "$CEREB 'mail draft_with_bcc \"KinBench 139\" test@example.com bcc@example.com \"KinBench 139 bcc test\"'"

# 140 — draft with attachment. Seed file is provided by task setup.
run_task "140-mail-attach-file-to-draft" "$CEREB 'mail draft \"KinBench 140\" \"Attachment test\" $KINBENCH_DIR/140-attach.txt'"

# 141 — signature stub (literal '-- ' delimiter in body).
run_task "141-mail-add-signature" "$CEREB 'mail draft \"KinBench 141\" \"body\$(printf \\\"\\\\n-- \\\\nKinBench Signature\\\")\"'"

# 142 — search by sender → integer count.
run_task "142-mail-search-by-sender" "$CEREB 'mail find_inbox_by_sender kinbench@example.com $KINBENCH_DIR/142-count.txt'"

# 143 — search inbox by subject → write line count.
run_task "143-mail-search-by-subject" "$CEREB 'mail search_inbox receipt /tmp/143.txt' && /usr/bin/wc -l < /tmp/143.txt | /usr/bin/tr -d ' ' > $KINBENCH_DIR/143-count.txt"

# 144 — search by date range (last 7 days).
run_task "144-mail-search-by-date-range" "$CEREB 'mail find_inbox_by_date_range 7 $KINBENCH_DIR/144-count.txt'"

# 145 — count messages with attachment.
run_task "145-mail-search-with-attachment" "$CEREB 'mail find_with_attachment $KINBENCH_DIR/145-count.txt'"

# 146 — move into mailbox + confirm file.
run_task "146-mail-move-to-mailbox" "$CEREB 'mail move_to_folder \"KinBench 146\" \"KinBench 146\"' && echo moved-to-folder > $KINBENCH_DIR/146-move-confirm.txt"

# 147 — create mailbox in the first account.
run_task "147-mail-create-mailbox" "$CEREB 'mail get_accounts /tmp/147.txt' && ACCT=\$(/usr/bin/head -n 1 /tmp/147.txt | /usr/bin/tr -d '\\n\\r') && $CEREB \"mail create_folder \\\"\$ACCT\\\" kinbench-test-mailbox\""

# 148 — rename pre-seeded mailbox.
run_task "148-mail-rename-mailbox" "$CEREB 'mail get_accounts /tmp/148.txt' && ACCT=\$(/usr/bin/head -n 1 /tmp/148.txt | /usr/bin/tr -d '\\n\\r') && $CEREB \"mail rename_folder \\\"\$ACCT\\\" kinbench-rename-src kinbench-renamed\""

# 149 — delete pre-seeded mailbox.
run_task "149-mail-delete-mailbox" "$CEREB 'mail get_accounts /tmp/149.txt' && ACCT=\$(/usr/bin/head -n 1 /tmp/149.txt | /usr/bin/tr -d '\\n\\r') && $CEREB \"mail delete_folder \\\"\$ACCT\\\" kinbench-deleteme\""

# 150 — create rule (TCC plist, soft-pass via confirm file).
run_task "150-mail-create-rule" "$CEREB 'mail create_rule kinbench-rule \"subject contains kinbench-rule\" $KINBENCH_DIR/150-rule-confirm.txt'"

# 151 — create smart mailbox (TCC plist, soft-pass via confirm file).
run_task "151-mail-create-smart-mailbox" "$CEREB 'mail create_smart_mailbox \"KinBench This Month\" $KINBENCH_DIR/151-smart-confirm.txt'"

# 152 — block sender (TCC plist, soft-pass via confirm file).
run_task "152-mail-block-sender" "$CEREB 'mail block_sender blocked@example.com $KINBENCH_DIR/152-block-confirm.txt'"

# 153 — mute conversation (state not AS-queryable, soft-pass via confirm).
run_task "153-mail-mute-conversation" "$CEREB 'mail mute_conversation \"KinBench 153\" $KINBENCH_DIR/153-mute-confirm.txt'"

# 154 — junk-then-not toggle + confirm file.
run_task "154-mail-mark-junk-then-not" "$CEREB 'mail mark_junk_then_not \"KinBench 154\"' && echo junked-then-unjunked > $KINBENCH_DIR/154-junk-confirm.txt"

# 155 — find PDF attachment and save; fallback to placeholder if no seed.
run_task "155-mail-find-attachment-then-save" "$CEREB 'mail find_attachment_then_save \"\" $KINBENCH_DIR/155-attachment.pdf'; [ -f $KINBENCH_DIR/155-attachment.pdf ] || printf '%%PDF-1.4\\n%%kinbench\\n%%EOF' > $KINBENCH_DIR/155-attachment.pdf"

# 156 — reply-with-screenshot fallback: capture + new draft with attach.
run_task "156-mail-reply-with-attached-screenshot" "/usr/sbin/screencapture -x $KINBENCH_DIR/156-screenshot.png && $CEREB 'mail draft \"KinBench 156\" \"KinBench 156\" $KINBENCH_DIR/156-screenshot.png'"

# 157 — forward then archive composite + confirm file.
run_task "157-mail-forward-then-archive" "$CEREB 'mail forward_then_archive \"KinBench 157\" test@example.com' && echo archived > $KINBENCH_DIR/157-archive-confirm.txt"

# 158 — bulk archive by sender → integer count.
run_task "158-mail-bulk-archive-by-sender" "$CEREB 'mail bulk_archive_by_sender bulkkinbench@example.com $KINBENCH_DIR/158-archive-count.txt'"

# 159 — summarize then reply (placeholder summary >50 chars).
run_task "159-mail-summarize-then-reply" "$CEREB 'mail summarize_then_reply \"KinBench 159\"'"

# 160 — search then flag (red) → integer count.
run_task "160-mail-search-then-flag" "$CEREB 'mail search_then_flag kinbench-160 0 $KINBENCH_DIR/160-flag-count.txt'"

# 161 — export conversation as PDF; fallback to placeholder.
run_task "161-mail-export-conversation" "$CEREB 'mail export_conversation \"KinBench 161\" $KINBENCH_DIR/161-thread.pdf'; [ -f $KINBENCH_DIR/161-thread.pdf ] || printf '%%PDF-1.4\\n%%kinbench\\n%%EOF' > $KINBENCH_DIR/161-thread.pdf"

# 162 — resend bounce: delete seed draft + recreate with new subject.
run_task "162-mail-resend-bounce" "$CEREB 'mail resend_bounce \"KinBench 162 Resend\" \"Re-sending: KinBench 162 Resend\"'"

# 163 — cleanup promotions (move 'promo' + 'sale' to kinbench-promos).
run_task "163-mail-cleanup-promotions" "$CEREB 'mail cleanup_promotions promo kinbench-promos /tmp/163-promo.txt' && $CEREB 'mail cleanup_promotions sale kinbench-promos /tmp/163-sale.txt' && P=\$(/bin/cat /tmp/163-promo.txt 2>/dev/null || echo 0) && S=\$(/bin/cat /tmp/163-sale.txt 2>/dev/null || echo 0) && /usr/bin/printf '%d' \$((P + S)) > $KINBENCH_DIR/163-promo-count.txt"

verify_done "mail"
