#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"
fail() { echo "FAIL: $*" >&2; exit 1; }
pass() { echo "PASS: $*"; }
for file in install.sh bin/cyberpunk bin/cyberpunk-banner.sh bin/cyberpunk-dashboard.sh bin/cyberpunk-voice.sh bin/cyberpunk-manager bin/cyberpunk-dashboard bin/cyberpunk-voice bin/cyberpunk-restore bin/cyberpunk-loader bin/cyberpunk-clean bin/cyberpunk-style bin/cyberpunk-art bin/cyberpunk-fonts bin/cyberpunk-update; do
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
for theme in cyberpunk.properties matrix.properties dracula.properties nord.properties gruvbox.properties solarized-dark.properties monokai.properties synthwave.properties; do
  [ -s "config/themes/$theme" ] || fail "missing theme: $theme"
  grep -q '^background=#' "config/themes/$theme" || fail "theme background: $theme"
  grep -q '^color15=#' "config/themes/$theme" || fail "theme color table: $theme"
done
pass "Theme collection and feature smoke checks"
echo "All Termux Cyberpunk static tests passed."
