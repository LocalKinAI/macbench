#!/bin/bash
# Reference verifier for macbench settings.
# Calls cerebellum (canonical shell, no LLM) for each task.
# Total runtime target: ~6 minutes.

set -u
SCRIPT_DIR="$(/usr/bin/dirname "$0")"
. "$SCRIPT_DIR/_verifier_lib.sh"

echo "═══════════════════════════════════════════════════════════════"
echo "  REFERENCE VERIFIER — settings (50 tasks)"
echo "═══════════════════════════════════════════════════════════════"

# --- core appearance / focus / pointer / display ---
run_task "004-settings-dark-mode"          "$CEREB 'settings set_dark_mode TRUE'"
run_task "021-settings-do-not-disturb"     "$CEREB 'settings toggle_dnd'"
run_task "022-settings-mouse-tracking"     "$CEREB 'settings toggle_mouse_tracking'"
run_task "023-settings-screensaver-time"   "$CEREB 'settings set_screensaver_idle 300'"
run_task "040-settings-volume"             "$CEREB 'settings set_volume 50'"
run_task "041-settings-hot-corner"         "$CEREB 'settings set_hot_corner br 2'"
run_task "042-settings-natural-scroll"     "$CEREB 'settings toggle_natural_scroll'"

# --- radios / focus daemons ---
run_task "240-settings-toggle-bluetooth"   "$CEREB 'settings toggle_bluetooth OFF'"
run_task "241-settings-toggle-wifi"        "$CEREB 'settings toggle_wifi OFF' && $CEREB 'settings toggle_wifi ON'"
run_task "242-settings-toggle-airdrop"     "$CEREB 'settings toggle_airdrop'"
run_task "243-settings-toggle-handoff"     "$CEREB 'settings toggle_handoff'"
run_task "244-settings-toggle-stage-manager" "$CEREB 'settings toggle_stage_manager'"
run_task "245-settings-toggle-night-shift" "$CEREB 'settings toggle_night_shift'"
run_task "246-settings-toggle-true-tone"   "$CEREB 'settings toggle_true_tone'"
run_task "247-settings-toggle-low-power"   "$CEREB 'settings toggle_low_power'"

# --- menu-bar visibility ---
run_task "248-settings-show-time-machine-menubar" "$CEREB 'settings show_time_machine_menubar'"
run_task "249-settings-show-battery-percent"      "$CEREB 'settings show_battery_percent'"

# --- dock ---
run_task "250-settings-add-dock-app"       "$CEREB 'settings add_dock_app /System/Applications/TextEdit.app'"
run_task "251-settings-remove-dock-app"    "$CEREB 'settings remove_dock_app TextEdit'"
run_task "252-settings-dock-position"      "$CEREB 'settings set_dock_position LEFT'"
run_task "253-settings-dock-size"          "$CEREB 'settings set_dock_size 16'"

# --- mission control / keyboard / input ---
run_task "254-settings-mission-control-spaces" "$CEREB 'settings create_space'"
run_task "255-settings-keyboard-repeat-rate"   "$CEREB 'settings set_keyboard_repeat 2'"
run_task "256-settings-keyboard-shortcut"      "$CEREB 'settings set_keyboard_shortcut com.apple.Safari \"About Safari\" \"@\$k\"'"
run_task "257-settings-input-source-add"       "$CEREB 'settings add_input_source en-GB'"
run_task "258-settings-input-source-remove"    "$CEREB 'settings remove_input_source'"

# --- displays (mostly soft-pass via pane open) ---
run_task "259-settings-display-resolution"        "$CEREB 'settings open com.apple.preference.displays'"
run_task "260-settings-display-multi-monitor"     "$CEREB 'settings count_displays $HOME/Desktop/kinbench/260-displays.txt' && $CEREB 'settings open_displays'"

# --- screen time (sandboxed; soft-pass via pane open) ---
run_task "261-settings-screen-time-enable"        "$CEREB 'settings open com.apple.preference.screentime'"
run_task "262-settings-screen-time-app-limit"     "$CEREB 'settings open com.apple.preference.screentime'"

# --- trackpad / mouse ---
run_task "263-settings-trackpad-tap-to-click"     "$CEREB 'settings toggle_trackpad_tap_to_click'"
run_task "264-settings-trackpad-three-finger-drag" "$CEREB 'settings set_three_finger_drag TRUE'"
run_task "265-settings-mouse-secondary-click"     "$CEREB 'settings set_mouse_secondary_click TwoButton'"

# --- printers / browsers / mail ---
run_task "266-settings-add-printer"               "$CEREB 'settings open_printers'"
run_task "267-settings-default-browser"           "$CEREB 'settings set_default_browser chrome'"
run_task "268-settings-default-mail"              "$CEREB 'settings set_default_mail com.google.Chrome'"

# --- login items ---
run_task "269-settings-add-login-item"            "$CEREB 'settings add_login_item /System/Applications/TextEdit.app'"
run_task "270-settings-remove-login-item"         "$CEREB 'settings remove_login_item TextEdit'"

# --- energy / firewall / screen saver / wallpaper ---
run_task "271-settings-energy-saver"              "$CEREB 'settings set_displaysleep 5'"
run_task "272-settings-firewall-enable"           "$CEREB 'settings enable_firewall'"
run_task "273-settings-screen-saver-pick"         "$CEREB 'settings set_screen_saver_module Hello'"
run_task "274-settings-wallpaper-change"          "$CEREB 'settings set_wallpaper /System/Library/Desktop\ Pictures/Solid\ Colors/Stone.png'"

# --- iCloud (sandboxed; soft-pass via pane open) ---
run_task "275-settings-icloud-toggle-photos"      "$CEREB 'settings open_icloud'"
run_task "276-settings-icloud-toggle-drive"       "$CEREB 'settings open_icloud'"

# --- bluetooth pairing pane ---
run_task "277-settings-bluetooth-pair"            "$CEREB 'settings toggle_bluetooth ON' && $CEREB 'settings open_bluetooth'"

# --- export defaults / restore shortcuts / bulk disable ---
run_task "278-settings-export-prefs"              "$CEREB 'settings export_prefs $HOME/Desktop/kinbench/278-defaults.plist'"
run_task "279-settings-restore-default-shortcuts" "$CEREB 'settings restore_default_shortcuts'"
run_task "280-settings-bulk-disable-startup"      "$CEREB 'settings bulk_disable_startup'"

# --- multi-display mirror toggle (writes status file) ---
run_task "281-settings-multi-display-mirror-toggle" "$CEREB 'settings mirror_displays_report $HOME/Desktop/kinbench/281-result.txt'"

# --- TCC: tccutil reset works for own-user revoke ---
run_task "282-settings-revoke-screen-recording"   "$CEREB 'settings revoke_screen_recording com.example.app'"

verify_done "settings"
