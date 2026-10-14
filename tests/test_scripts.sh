#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"
fail() { echo "FAIL: $*" >&2; exit 1; }
pass() { echo "PASS: $*"; }
for file in install.sh bin/cyberpunk bin/cyberpunk-banner.sh bin/cyberpunk-dashboard.sh bin/cyberpunk-voice.sh bin/cyberpunk-manager bin/cyberpunk-dashboard bin/cyberpunk-voice bin/cyberpunk-restore bin/cyberpunk-loader bin/cyberpunk-clean bin/cyberpunk-style bin/cyberpunk-art bin/cyberpunk-fonts bin/cyberpunk-update bin/cyberpunk-plugins bin/cyberpunk-backup bin/cyberpunk-listen bin/cyberpunk-monitor; do
  bash -n "$file" || fail "Bash syntax: $file"
done
pass "Bash syntax checks"
grep -q 'background=#05080A' config/colors.properties || fail "cyberpunk background palette"
grep -q 'extra-keys' config/termux.properties || fail "extra keys configuration"
grep -q 'CYBERPUNK_VOICE_GREETING' bin/cyberpunk-voice.sh || fail "configurable voice greeting"
grep -q 'termux-tts-speak -p' bin/cyberpunk-voice.sh || fail "voice pitch/rate controls"
grep -q 'CYBERPUNK_AUTO_START' install.sh || fail "automatic startup setting"
grep -q 'cyberpunk-loader' install.sh || fail "digital loading screen installation"
grep -q 'cyberpunk-clean' install.sh || fail "clean settings manager installation"
grep -q 'Type FRESH to confirm' bin/cyberpunk-clean || fail "fresh install confirmation"
grep -q 'cyberpunk-manager' install.sh || fail "manager installation"
grep -q 'cyberpunk-style' install.sh || fail "theme selector installation"
grep -q 'cyberpunk-art' install.sh || fail "banner tool installation"
grep -q 'cyberpunk-fonts' install.sh || fail "font manager installation"
grep -q 'cyberpunk-update' install.sh || fail "updater installation"
grep -q 'MARK_START' bin/cyberpunk-restore || fail "managed .bashrc block restore"
grep -q -- '--watch' bin/cyberpunk-dashboard.sh || fail "dashboard watch mode"
grep -q 'CYBERPUNK_STARTUP_COMMAND' bin/cyberpunk || fail "custom startup command support"
grep -q 'Set startup command/app' bin/cyberpunk-manager || fail "startup command manager menu"
grep -q 'Plugin manager' bin/cyberpunk-manager || fail "plugin manager menu"
grep -q 'cyberpunk-backup' bin/cyberpunk-manager || fail "backup manager menu"
grep -q 'termux-speech-to-text' bin/cyberpunk-listen || fail "voice shortcut support"
grep -q 'manual-backups' bin/cyberpunk-backup || fail "manual backup storage"
grep -q 'Network counters' bin/cyberpunk-monitor || fail "live monitor network counters"
grep -q 'Review the source' bin/cyberpunk-plugins || fail "plugin manager safety guidance"
if grep -qE 'Storage|Battery|termux-battery-status|df -h' bin/cyberpunk-dashboard.sh; then fail "dashboard should omit storage and battery details"; fi
for theme in cyberpunk.properties matrix.properties dracula.properties nord.properties gruvbox.properties solarized-dark.properties monokai.properties synthwave.properties ocean.properties amber.properties bloodmoon.properties forest.properties arctic.properties vaporwave.properties plasma-breeze.properties; do
  [ -s "config/themes/$theme" ] || fail "missing theme: $theme"
  grep -q '^background=#' "config/themes/$theme" || fail "theme background: $theme"
  grep -q '^color15=#' "config/themes/$theme" || fail "theme color table: $theme"
done
pass "Theme collection and feature smoke checks"
TMP_HOME="$(mktemp -d)"
trap 'rm -rf "$TMP_HOME"' EXIT
HOME="$TMP_HOME" bash bin/cyberpunk-plugins create ci-test >/dev/null || fail "plugin creation"
HOME="$TMP_HOME" bash bin/cyberpunk-plugins run ci-test | grep -q 'Hello from your Cyberpunk plugin' || fail "plugin execution"
HOME="$TMP_HOME" bash bin/cyberpunk-backup create >/dev/null || fail "backup creation"
HOME="$TMP_HOME" bash bin/cyberpunk-backup list | grep -qE '[0-9]{8}-[0-9]{6}' || fail "backup listing"
pass "Plugin and backup smoke tests"
echo "All Termux Cyberpunk tests passed."
