#!/usr/bin/env bash
# warmup.sh — pre-bench environment reset + TCC health check.
#
# Run before every `make bench` (or let `make bench` invoke it
# automatically). Does four things in order:
#
#   1. Force-quit every app the bench touches (Safari, Mail, Notes,
#      Calendar, Reminders, Music, Photos, Maps, TextEdit, etc.)
#      so each task starts from a known clean state. Without this,
#      a tab/window/draft left over from task N pollutes task N+1.
#
#   2. Wipe the bench sandbox dirs (~/Desktop/kinbench/, ~/.kinbench/)
#      so per-task setup.sh starts from empty.
#
#   3. Clean any KinBench-prefix data still hiding inside Notes /
#      Reminders / Calendar / Mail Drafts (from prior runs that
#      crashed before teardown).
#
#   4. Probe each app via osascript with a 5-second timeout. Report
#      each one as ✓ healthy / ⚠ hung / ❌ TCC denied. The user
#      should grant any "Allow osascript to control X" prompts that
#      pop up during this step, then re-run.
#
# Exits 0 even if some probes fail (warmup is best-effort; the
# bench runner gracefully degrades). The exit message tells you
# which probes need attention before bench gets meaningful numbers
# from those task categories.

set -uo pipefail

OK="✓"
WARN="⚠"
FAIL="✗"

probe_timeout=5

probe() {
  local app="$1" script="$2"
  local out
  out="$(timeout "$probe_timeout" osascript -e "$script" 2>&1)"
  local code=$?
  if [[ $code -eq 0 ]]; then
    printf "  %s %-16s ok\n" "$OK" "$app"
    return 0
  elif [[ $code -eq 124 ]]; then
    printf "  %s %-16s HUNG (osascript didn't return in %ss — app likely in bad state)\n" "$WARN" "$app" "$probe_timeout"
    return 1
  elif printf '%s' "$out" | grep -q -- "-1743"; then
    printf "  %s %-16s TCC DENIED — grant Automation in System Settings → Privacy & Security → Automation\n" "$FAIL" "$app"
    return 2
  elif printf '%s' "$out" | grep -q -- "-600"; then
    printf "  %s %-16s not running (will auto-launch when bench needs it)\n" "$OK" "$app"
    return 0
  else
    printf "  %s %-16s err: %s\n" "$WARN" "$app" "$(printf '%s' "$out" | head -1)"
    return 1
  fi
}

# ─── 0. Prevent screen sleep / lock during the bench ─────────────────────────
# A task may set a short screensaver timer (e.g. 023-settings-screensaver-time).
# If the screen sleeps mid-run, every subsequent UI-automation task hangs
# until per-task timeout — losing 90s × N tasks. Run caffeinate in the
# background to block idle sleep and display sleep for 8 hours. Killed
# automatically when warmup's parent shell exits, or via `pkill caffeinate`.
echo "[1/5] caffeinating (block display+system sleep for 8h)…"
# Kill any stale caffeinate from a prior aborted run, then start fresh.
pkill -f "caffeinate -dimsu" 2>/dev/null || true
caffeinate -dimsu -t 28800 >/dev/null 2>&1 &
disown 2>/dev/null || true
printf "  %s caffeinate running (pid %s)\n" "$OK" "$!"

# ─── 1. Force-quit bench-touched apps ────────────────────────────────────────
echo "[2/5] quitting bench-touched apps…"
for app in Safari Mail Notes Reminders Calendar Music Photos Maps TextEdit Pages Numbers Keynote "System Settings" "System Preferences"; do
  killall "$app" 2>/dev/null && printf "  %s killed %s\n" "$OK" "$app" || true
done
sleep 1

# ─── 2. Wipe sandbox ─────────────────────────────────────────────────────────
echo "[3/5] wiping sandbox (~/Desktop/kinbench, ~/.kinbench)…"
rm -rf "$HOME/Desktop/kinbench" "$HOME/.kinbench"
mkdir -p "$HOME/Desktop/kinbench"
echo "  $OK sandbox empty"

# ─── 3. Clean KinBench-prefix data inside apps ───────────────────────────────
# Each cleanup is timeout-protected so a hung app doesn't hang warmup.
echo "[4/5] clearing KinBench-prefix items in app data stores…"

clean_with_timeout() {
  local label="$1" script="$2"
  if timeout 30 osascript -e "$script" >/dev/null 2>&1; then
    printf "  %s %s\n" "$OK" "$label"
  else
    printf "  %s %s (timed out — manual cleanup may be needed)\n" "$WARN" "$label"
  fi
}

clean_with_timeout "Notes (prefix=KinBench)" '
tell application "Notes"
    repeat with n in (every note whose name starts with "KinBench")
        try
            delete n
        end try
    end repeat
    repeat with f in (every folder whose name starts with "kinbench")
        try
            delete f
        end try
    end repeat
end tell'

clean_with_timeout "Reminders (prefix=KinBench/kinbench)" '
tell application "Reminders"
    repeat with lst in lists
        try
            repeat with r in (every reminder of lst whose name starts with "KinBench")
                try
                    delete r
                end try
            end repeat
        end try
    end repeat
    repeat with lst in (every list whose name starts with "kinbench")
        try
            delete lst
        end try
    end repeat
end tell'

clean_with_timeout "Calendar (prefix=KinBench)" '
tell application "Calendar"
    repeat with cal in calendars
        try
            repeat with ev in (every event of cal whose summary starts with "KinBench")
                delete ev
            end repeat
        end try
    end repeat
end tell'

clean_with_timeout "Mail Drafts (prefix=KinBench)" '
tell application "Mail"
    repeat with acct in accounts
        try
            repeat with m in (every message of (mailbox "Drafts" of acct) whose subject starts with "KinBench")
                delete m
            end repeat
        end try
    end repeat
end tell'

clean_with_timeout "Photos albums (prefix=KinBench)" '
tell application "Photos"
    repeat with a in (every album whose name starts with "KinBench")
        try
            delete a
        end try
    end repeat
end tell'

clean_with_timeout "Music playlists (prefix=KinBench)" '
tell application "Music"
    repeat with p in (every playlist whose name starts with "KinBench")
        try
            delete p
        end try
    end repeat
end tell'

# Quit again — the cleanup operations may have re-launched the apps.
for app in Notes Reminders Calendar Mail Photos Music; do
  killall "$app" 2>/dev/null || true
done
sleep 1

# ─── 4. TCC + responsiveness probe ───────────────────────────────────────────
echo "[5/5] probing each app's osascript via TCC…"
fail=0
probe Mail      'tell application "Mail" to count of accounts' || fail=$((fail+1))
probe Notes     'tell application "Notes" to count of (every note whose name = "__warmup_probe")' || fail=$((fail+1))
probe Calendar  'tell application "Calendar" to count of calendars' || fail=$((fail+1))
probe Reminders 'tell application "Reminders" to count of lists' || fail=$((fail+1))
probe Safari    'tell application "Safari" to running' || fail=$((fail+1))
probe Music     'tell application "Music" to count of playlists' || fail=$((fail+1))
probe Photos    'tell application "Photos" to count of albums' || fail=$((fail+1))
probe Finder    'tell application "Finder" to count of windows' || fail=$((fail+1))
probe "System Events" 'tell application "System Events" to count of processes' || fail=$((fail+1))

# Quit any apps the probes inadvertently launched.
for app in Mail Notes Reminders Calendar Safari Music Photos; do
  killall "$app" 2>/dev/null || true
done

echo ""
if [[ "$fail" -eq 0 ]]; then
  echo "ready — all probes passed. you can now run 'make bench'."
else
  echo "warmup finished with $fail probe issue(s) above."
  echo "→ if any showed 'TCC DENIED', grant the Automation prompt and re-run."
  echo "→ if any showed 'HUNG', the app is in a bad state — restart it manually."
  echo "→ bench will still run, but tasks targeting unhealthy apps will fail."
fi
