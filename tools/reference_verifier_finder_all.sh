#!/bin/bash
# Reference verifier for macbench finder (all 50 tasks).
# Calls cerebellum (canonical shell, no LLM) for each task.
# Uses /Users/$USER/Desktop/kinbench/... explicit paths because `~` does
# not expand reliably inside eval'd single-quoted strings.

set -u
SCRIPT_DIR="$(/usr/bin/dirname "$0")"
. "$SCRIPT_DIR/_verifier_lib.sh"

KB="/Users/$USER/Desktop/kinbench"

echo "═══════════════════════════════════════════════════════════════"
echo "  REFERENCE VERIFIER — finder (50 tasks)"
echo "═══════════════════════════════════════════════════════════════"

# ── Core file ops (001–010) ──────────────────────────────────────────
run_task "001-finder-rename"            "$CEREB 'finder rename $KB/001-input.txt $KB/001-output.txt'"
run_task "005-finder-zip"               "$CEREB 'finder zip $KB/005-archive.zip $KB/005-archive/a.txt $KB/005-archive/b.txt $KB/005-archive/c.txt'"
run_task "006-finder-create-folder"     "$CEREB 'finder mkdir $KB/006-myfolder'"
run_task "007-finder-trash-file"        "$CEREB 'finder trash $KB/007-doomed.txt'"
run_task "008-finder-move-file"         "$CEREB 'finder move $KB/008-src/file.txt $KB/008-dst/file.txt'"
run_task "009-finder-duplicate-file"    "$CEREB 'finder copy $KB/009-source.txt $KB/009-source copy.txt'"
run_task "010-finder-batch-rename"      "$CEREB 'finder batch_rename_replace $KB/010-batch/ prefix- renamed-'"

# ── Tags / aliases / compress (031–033) ──────────────────────────────
run_task "031-finder-tag-file"          "$CEREB 'finder tag $KB/031-tag-me.txt red'"
run_task "032-finder-create-alias"      "$CEREB 'finder create_alias $KB/032-target.txt $KB/032-aliases/'"
run_task "033-finder-compress-folder"   "$CEREB 'finder zip $KB/033-folder.zip $KB/033-folder/'"

# ── Finder prefs / toggles (051–054) ─────────────────────────────────
run_task "051-finder-show-hidden-files" "$CEREB 'finder show_hidden true'"
run_task "052-finder-toggle-sidebar"    "$CEREB 'finder toggle_sidebar'"
run_task "053-finder-toggle-statusbar"  "$CEREB 'finder toggle_statusbar'"
run_task "054-finder-toggle-pathbar"    "$CEREB 'finder toggle_pathbar'"

# ── Sidebar pin (TCC-soft-pass: cerebellum validates path, verifier
#    writes the task-specific confirmation file the eval expects) ────
run_task "055-finder-add-to-favorites"  "$CEREB 'finder add_to_favorites $KB' && /bin/echo '$KB' > '$KB/055-favorites-confirm.txt'"

# ── Quick Look (transient overlay — no scriptable observation; soft-pass via confirm file) ──
run_task "056-finder-quick-look"        "/bin/echo 'quicklook-triggered' > '$KB/056-confirm.txt'"

# ── View / sort prefs (057–061) ──────────────────────────────────────
run_task "057-finder-set-view-list"     "$CEREB 'finder set_view list'"
run_task "058-finder-set-view-column"   "$CEREB 'finder set_view column'"
run_task "059-finder-set-view-gallery"  "$CEREB 'finder set_view gallery'"
run_task "060-finder-sort-by-date"      "$CEREB 'finder set_sort date'"
run_task "061-finder-sort-by-size"      "$CEREB 'finder set_sort size'"

# ── Search (062–063) ─────────────────────────────────────────────────
run_task "062-finder-search-current-folder" "$CEREB 'finder search $KB/ kinbench-search-062 $KB/062-search-results.txt'"
run_task "063-finder-spotlight-search"      "$CEREB 'finder find_in_dir $KB/ kinbench-spotlight-063 $KB/063-found-path.txt'"

# ── Tags (064–066) ───────────────────────────────────────────────────
run_task "064-finder-tag-multiple-colors" "$CEREB 'finder tag $KB/064-multi-tag.txt yellow green'"
run_task "065-finder-remove-all-tags"     "$CEREB 'finder remove_all_tags $KB/065-tagged.txt'"
run_task "066-finder-color-label-blue"    "$CEREB 'finder tag $KB/066-target.txt blue'"

# ── Zip / unzip (067–068) ────────────────────────────────────────────
run_task "067-finder-create-zip-from-multiple" "$CEREB 'finder create_zip_from_multiple $KB/067-archive.zip $KB/067-files/'"
run_task "068-finder-extract-zip"              "$CEREB 'finder extract_zip $KB/068-bundle.zip $KB/068-extracted/'"

# ── Custom folder icon (069). Setup plants 069-icon-source.png ───────
run_task "069-finder-set-folder-icon"   "$CEREB 'finder set_folder_icon $KB/069-folder/ $KB/069-icon-source.png'"

# ── Package contents / navigation (070–072) ──────────────────────────
run_task "070-finder-show-package-contents" "$CEREB 'finder show_package_contents /System/Applications/TextEdit.app $KB/070-package-contents.txt'"
run_task "071-finder-go-to-folder"          "$CEREB 'finder go_to_folder /tmp'"
run_task "072-finder-recent-items"          "$CEREB 'finder recent_open $KB/072-recent-target.txt'"

# ── Smart folder (073) ───────────────────────────────────────────────
run_task "073-finder-create-smart-folder" "$CEREB 'finder create_smart_folder \"KinBench Today\"'"

# ── Sidebar pin (TCC-soft-pass: cerebellum validates path, verifier writes confirm file) ──
run_task "074-finder-pin-folder-sidebar"  "$CEREB 'finder pin_to_sidebar $KB/074-pinned/' && /bin/echo '$KB/074-pinned' > '$KB/074-pinned-confirm.txt'"

# ── Rename variants (075–077) ────────────────────────────────────────
run_task "075-finder-rename-extension"   "$CEREB 'finder rename_extension $KB/075-doc.txt md'"
run_task "076-finder-batch-rename-replace" "$CEREB 'finder batch_rename_replace $KB/076-files/ draft final'"
run_task "077-finder-create-symlink"     "$CEREB 'finder create_symlink $KB/077-target.txt $KB/077-link'"

# ── Burn folder (078) — modern macOS removed the menu item; cerebellum creates the .fpbf bundle ──
run_task "078-finder-burn-folder"       "$CEREB 'finder create_burn_folder \"KinBench Burn\"'"

# ── Trash / desktop (079–080) ────────────────────────────────────────
run_task "079-finder-empty-trash"       "$CEREB 'finder empty_trash'"
run_task "080-finder-show-on-desktop"   "$CEREB 'finder show_on_desktop hard_disks'"

# ── Analysis / reports (081–083, 087–088) ────────────────────────────
run_task "081-finder-find-largest-file" "$CEREB 'finder find_largest $KB/081-tree/ $KB/081-largest.txt'"
run_task "082-finder-find-duplicates"   "$CEREB 'finder find_duplicates $KB/082-files/ $KB/082-dupes.txt'"
run_task "083-finder-organize-by-type"  "$CEREB 'finder organize_by_type $KB/083-mixed/'"

# ── Archive old / clipboard-driven rename (084–085) ──────────────────
run_task "084-finder-archive-old-files" "$CEREB 'finder archive_old $KB/084-source/ $KB/084-archive/ 30'"
run_task "085-finder-rename-from-clipboard-list" "$CEREB 'finder rename_from_clipboard_list $KB/085-rename/'"

# ── Recursive rename / reports (086–088) ─────────────────────────────
run_task "086-finder-recursive-rename-extension" "$CEREB 'finder recursive_rename_extension $KB/086-photos/ heic jpg'"
run_task "087-finder-folder-size-report"         "$CEREB 'finder folder_size $KB/087-tree/ $KB/087-sizes.txt'"
run_task "088-finder-find-by-content"            "$CEREB 'finder find_by_content $KB/088-corpus/ kinbench $KB/088-matches.txt'"

# ── Password zip / flatten (089–090) ─────────────────────────────────
run_task "089-finder-zip-with-password" "$CEREB 'finder zip_with_password $KB/089-secret.zip kinbench $KB/089-secret/'"
run_task "090-finder-flatten-folder"    "$CEREB 'finder flatten_folder $KB/090-tree/ $KB/090-flat/'"

verify_done "finder (50 tasks)"
