#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "\${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"
fail() { echo "FAIL: $*" >&2; exit 1; }
pass() { echo "PASS: $*"; }
for file in install.sh bin/cyberpunk bin/cyberpunk-banner.sh bin/cyberpunk-dashboard.sh bin/cyberpunk-voice.sh bin/cyberpunk-manager bin/cyberpunk-dashboard bin/cyberpunk-voice bin/cyberpunk-restore; do
  bash -n "$file" || fail "Bash syntax: $file"
done
pass "Bash syntax checks"
grep -q 'background=#05080A' config/colors.properties || fail "cyberpunk background palette"
grep -q 'extra-keys' config/termux.properties || fail "extra keys configuration"
grep -q 'CYBERPUNK_VOICE_GREETING' bin/cyberpunk-voice.sh || fail "configurable voice greeting"
grep -q 'cyberpunk-manager' install.sh || fail "manager installation"
grep -q 'MARK_START' bin/cyberpunk-restore || fail "managed .bashrc block restore"
grep -q -- '--watch' bin/cyberpunk-dashboard.sh || fail "dashboard watch mode"
pass "Configuration and feature smoke checks"
echo "All Termux Cyberpunk static tests passed."
