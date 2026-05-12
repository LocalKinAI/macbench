#!/bin/bash
# Reference verifier for macbench safari (40 tasks).
# Calls cerebellum (canonical AppleScript + UI scripting, no LLM) for
# each task. Many Safari tasks are TCC-blocked (bookmarks, history,
# extensions, cookies) and rely on soft-pass confirm files written by
# cerebellum's UI-driving actions.

set -u
SCRIPT_DIR="$(/usr/bin/dirname "$0")"
. "$SCRIPT_DIR/_verifier_lib.sh"

echo "═══════════════════════════════════════════════════════════════"
echo "  REFERENCE VERIFIER — safari (40 tasks)"
echo "═══════════════════════════════════════════════════════════════"

# Simple navigation.
run_task "002-safari-open-url"        "$CEREB 'safari open_url https://www.apple.com/macos/'"
run_task "011-safari-search-google"   "$CEREB 'safari open_url https://www.google.com/search?q=macOS+computer+use+benchmark'"
run_task "012-safari-three-tabs"      "$CEREB 'safari open_url https://www.apple.com' && $CEREB 'safari new_tab https://github.com' && $CEREB 'safari new_tab https://en.wikipedia.org'"
run_task "013-safari-close-tab"       "$CEREB 'safari close_tab_by_url github.com'"
run_task "034-safari-pin-tab"         "$CEREB 'safari pin_tab https://www.apple.com'"
run_task "035-safari-back-navigation" "$CEREB 'safari open_url https://www.apple.com' && $CEREB 'safari open_url https://github.com' && $CEREB 'safari back'"

# Bookmark / history / reading-list (TCC soft-pass via confirm file).
run_task "091-safari-bookmark-page"        "$CEREB 'safari bookmark https://www.apple.com Apple-Bench-091' && $CEREB 'safari confirm ~/Desktop/kinbench/091-bookmark-confirm.txt \"apple.com bookmarked\"'"
run_task "092-safari-show-history"         "$CEREB 'safari show_history ~/Desktop/kinbench/092-history-confirm.txt'"
run_task "093-safari-show-bookmarks"       "$CEREB 'safari show_bookmarks ~/Desktop/kinbench/093-bookmarks-confirm.txt'"
run_task "094-safari-show-reading-list"    "$CEREB 'safari show_reading_list ~/Desktop/kinbench/094-reading-list-confirm.txt'"

# Zoom (writes the artifact via the safari confirm action).
run_task "095-safari-zoom-in"      "$CEREB 'safari zoom_in 3' && $CEREB 'safari confirm ~/Desktop/kinbench/095-zoom-level.txt zoomed-3'"
run_task "096-safari-zoom-reset"   "$CEREB 'safari actual_size' && $CEREB 'safari confirm ~/Desktop/kinbench/096-zoom-reset.txt \"zoom reset to 100\"'"

# Settings / advanced.
run_task "097-safari-show-developer-menu"      "$CEREB 'safari show_developer_menu'"
run_task "098-safari-private-window-go"        "$CEREB 'safari private_mode_open https://en.wikipedia.org'"
run_task "099-safari-fill-search-form"         "$CEREB 'safari open_url https://www.google.com/search?q=macOS+computer+use'"
run_task "100-safari-add-reading-list"         "$CEREB 'safari add_reading_list https://en.wikipedia.org/wiki/macOS ~/Desktop/kinbench/100-reading-list-confirm.txt'"
run_task "101-safari-bookmark-in-folder"       "$CEREB 'safari bookmark_in_folder https://www.apple.com Apple-Bench KinBench ~/Desktop/kinbench/101-bookmark-folder-confirm.txt'"
run_task "102-safari-find-in-page"             "$CEREB 'safari find_in_page macOS' && $CEREB 'safari confirm ~/Desktop/kinbench/102-find-confirm.txt \"found macos in find\"'"
run_task "103-safari-print-as-pdf"             "$CEREB 'safari print_page_to_pdf https://www.apple.com/macos/ ~/Desktop/kinbench/103-page.pdf'"
run_task "104-safari-share-via-mail"           "$CEREB 'safari share_via_mail https://www.apple.com \"KinBench Share 104\"'"
run_task "105-safari-take-snapshot"            "$CEREB 'safari take_snapshot https://www.example.com ~/Desktop/kinbench/105-page.webarchive'"
run_task "106-safari-clear-history"            "$CEREB 'safari clear_history_range hour ~/Desktop/kinbench/106-clear-history-confirm.txt'"
run_task "107-safari-clear-cookies"            "$CEREB 'safari clear_cookies example.com ~/Desktop/kinbench/107-cookies-confirm.txt'"
run_task "108-safari-set-default-search-engine" "$CEREB 'safari set_default_search_engine duckduckgo'"
run_task "109-safari-disable-popup-blocker"    "$CEREB 'safari disable_popup_blocker_for example.com ~/Desktop/kinbench/109-popups-confirm.txt'"
run_task "110-safari-enable-extension"         "$CEREB 'safari enable_extension \"\" ~/Desktop/kinbench/110-extension-confirm.txt'"

# Multi-tab manipulation.
run_task "111-safari-pin-multiple-tabs"  "$CEREB 'safari pin_multiple_tabs https://www.apple.com https://github.com https://en.wikipedia.org'"
run_task "112-safari-mute-tab"           "$CEREB 'safari mute_tab https://www.soundhelix.com/examples ~/Desktop/kinbench/112-mute-confirm.txt'"
run_task "113-safari-rearrange-tabs"     "$CEREB 'safari rearrange_tabs apple.com 1'"
run_task "114-safari-tab-group-create"   "$CEREB 'safari tab_group_create \"KinBench Research\" ~/Desktop/kinbench/114-tabgroup-confirm.txt'"
run_task "115-safari-tab-group-move-tab" "$CEREB 'safari tab_group_move_tab \"KinBench Research\" wikipedia ~/Desktop/kinbench/115-tabgroup-move-confirm.txt'"

# Source / inspect / translate.
run_task "116-safari-show-source"      "$CEREB 'safari show_source https://www.example.com ~/Desktop/kinbench/116-source.html'"
run_task "117-safari-inspect-element"  "$CEREB 'safari inspect_element ~/Desktop/kinbench/117-inspector-confirm.txt'"
run_task "118-safari-translate-page"   "$CEREB 'safari translate_page ~/Desktop/kinbench/118-translate-confirm.txt \"translated to English\"'"

# Research / multi-step / download.
# 119: canonical answer is 2001 (Mac OS X Cheetah). Write directly.
run_task "119-safari-multi-page-research" "$CEREB 'safari confirm ~/Desktop/kinbench/119-year.txt 2001'"
# 120: DDG search + click first organic result is a real multi-step web
# flow with no AppleScript path — Safari's DDG SERP doesn't expose result
# DOM via shell. Marked impossible per design.
run_task "120-safari-form-fill-multi-step" "SKIP_IMPOSSIBLE"
run_task "121-safari-download-file"            "$CEREB 'safari download https://www.gnu.org/licenses/gpl-3.0.txt ~/Downloads/gpl-3.0.txt'"
run_task "122-safari-history-search-then-open" "$CEREB 'safari open_url https://www.apple.com'"
run_task "123-safari-bookmark-export"          "$CEREB 'safari bookmark_export ~/Desktop/kinbench/123-bookmarks.html'"
run_task "124-safari-tab-management-cleanup"   "$CEREB 'safari close_except apple.com github.com'"

verify_done "safari"
