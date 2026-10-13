#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
for required in config/colors.properties config/termux.properties bin/cyberpunk bin/cyberpunk-banner.sh bin/cyberpunk-dashboard.sh bin/cyberpunk-voice.sh bin/cyberpunk-manager bin/cyberpunk-restore bin/cyberpunk-loader bin/cyberpunk-clean bin/cyberpunk-style bin/cyberpunk-art bin/cyberpunk-fonts bin/cyberpunk-update; do
  [ -f "$ROOT/$required" ] || { echo "Missing project file: $required" >&2; exit 1; }
done
[ -d "$ROOT/config/themes" ] || { echo "Missing theme collection: config/themes" >&2; exit 1; }
if ! command -v pkg >/dev/null 2>&1; then echo "This installer requires Termux's pkg command. Run it inside Termux." >&2; exit 1; fi
echo "Checking required Termux packages..."
pkg install -y bash coreutils procps
pkg install -y figlet toilet lolcat || echo "Optional FIGlet/TOIlet/lolcat packages unavailable; built-in banners still work."
BACKUP_ROOT="$HOME/.local/share/termux-cyberpunk/backups"
mkdir -p "$BACKUP_ROOT"
BASELINE="$BACKUP_ROOT/original"
if [ ! -d "$BASELINE" ]; then
  mkdir -p "$BASELINE/installed"
  FIRST_EXISTING="$(find "$BACKUP_ROOT" -mindepth 1 -maxdepth 1 -type d ! -name original | sort | head -n 1)"
  if [ -n "$FIRST_EXISTING" ]; then
    for f in bashrc colors.properties termux.properties created-by-installer.txt; do [ ! -f "$FIRST_EXISTING/$f" ] || cp -p "$FIRST_EXISTING/$f" "$BASELINE/$f"; done
  else
    for pair in ".bashrc:bashrc" ".termux/colors.properties:colors.properties" ".termux/termux.properties:termux.properties"; do
      src="${pair%%:*}"; name="${pair##*:}"
      if [ -f "$HOME/$src" ]; then cp -p "$HOME/$src" "$BASELINE/$name"; else echo "$src" >> "$BASELINE/created-by-installer.txt"; fi
    done
  fi
fi
STAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP="$BACKUP_ROOT/$STAMP"
mkdir -p "$BACKUP/installed" "$HOME/.termux" "$HOME/.config/termux-cyberpunk" "$HOME/.local/bin" "$HOME/.local/share/termux-cyberpunk"
for pair in ".bashrc:bashrc" ".termux/colors.properties:colors.properties" ".termux/termux.properties:termux.properties"; do
  src="${pair%%:*}"; name="${pair##*:}"
  if [ -f "$HOME/$src" ]; then cp -p "$HOME/$src" "$BACKUP/$name"; fi
done
for f in ".bashrc" ".termux/colors.properties" ".termux/termux.properties"; do [ -e "$HOME/$f" ] || echo "$f" >> "$BACKUP/created-by-installer.txt"; done
PRESERVE_COLORS=0
PRESERVE_PROPERTIES=0
if [ -f "$BASELINE/installed/colors.properties" ] && [ -f "$HOME/.termux/colors.properties" ] && ! cmp -s "$HOME/.termux/colors.properties" "$BASELINE/installed/colors.properties"; then PRESERVE_COLORS=1; fi
if [ -f "$BASELINE/installed/termux.properties" ] && [ -f "$HOME/.termux/termux.properties" ] && ! cmp -s "$HOME/.termux/termux.properties" "$BASELINE/installed/termux.properties"; then PRESERVE_PROPERTIES=1; fi
if [ "$PRESERVE_COLORS" = 0 ]; then cp "$ROOT/config/colors.properties" "$HOME/.termux/colors.properties"; else echo "Preserving customized terminal colors."; fi
if [ "$PRESERVE_PROPERTIES" = 0 ]; then cp "$ROOT/config/termux.properties" "$HOME/.termux/termux.properties"; else echo "Preserving customized Termux properties."; fi
for file in cyberpunk cyberpunk-banner.sh cyberpunk-dashboard.sh cyberpunk-voice.sh cyberpunk-dashboard cyberpunk-voice cyberpunk-manager cyberpunk-restore cyberpunk-loader cyberpunk-clean cyberpunk-style cyberpunk-art cyberpunk-fonts cyberpunk-update; do cp "$ROOT/bin/$file" "$HOME/.local/bin/$file"; done
THEME_HOME="$HOME/.local/share/termux-cyberpunk/themes"
mkdir -p "$THEME_HOME"
cp "$ROOT"/config/themes/*.properties "$THEME_HOME/"
printf '%s\n' "$ROOT" > "$HOME/.local/share/termux-cyberpunk/repo-path"
chmod +x "$HOME"/.local/bin/cyberpunk "$HOME"/.local/bin/cyberpunk-* "$HOME"/.local/bin/cyberpunk-restore
if [ ! -f "$HOME/.config/termux-cyberpunk/config" ]; then
  cat > "$HOME/.config/termux-cyberpunk/config" <<'CFG'
CYBERPUNK_ANIMATION=1
CYBERPUNK_LOADING=1
CYBERPUNK_AUTO_START=1
CYBERPUNK_AUTO_VOICE=0
CYBERPUNK_VOICE_STYLE=cinematic
CYBERPUNK_VOICE_PITCH=0.82
CYBERPUNK_VOICE_RATE=0.90
CYBERPUNK_VOICE_GREETING="Good evening. All systems are online. How may I assist you?"
CYBERPUNK_STARTUP_COMMAND_B64=''
CFG
fi
for target in "$BACKUP" "$BASELINE"; do
  mkdir -p "$target/installed"
  cp "$ROOT/config/colors.properties" "$target/installed/colors.properties"
  cp "$ROOT/config/termux.properties" "$target/installed/termux.properties"
done
touch "$HOME/.bashrc"
TMP_BASHRC="$(mktemp "$HOME/.bashrc.cyberpunk.XXXXXX")"
awk -v start="# >>> termux-cyberpunk >>>" -v end="# <<< termux-cyberpunk <<<" '$0==start {skip=1; next} $0==end {skip=0; next} !skip {print}' "$HOME/.bashrc" > "$TMP_BASHRC"
cat "$TMP_BASHRC" > "$HOME/.bashrc"
rm -f "$TMP_BASHRC"
cat >> "$HOME/.bashrc" <<'BASHRC'

# >>> termux-cyberpunk >>>
export PATH="$HOME/.local/bin:$PATH"
if [[ $- == *i* ]]; then
  CYBERPUNK_CONFIG="$HOME/.config/termux-cyberpunk/config"
  if [[ -f "$CYBERPUNK_CONFIG" ]]; then . "$CYBERPUNK_CONFIG"; fi
  if [[ "${CYBERPUNK_AUTO_START:-1}" == "1" ]] && [[ -x "$HOME/.local/bin/cyberpunk" ]]; then
    "$HOME/.local/bin/cyberpunk"
  fi
fi
# <<< termux-cyberpunk <<<
BASHRC
export PATH="$HOME/.local/bin:$PATH"
echo
echo "Cyberpunk theme installed."
echo "Backup: $BACKUP"
echo "Original baseline: $BASELINE"
echo "Commands: cyberpunk, cyberpunk-manager, cyberpunk-style --list, cyberpunk-art --list, cyberpunk-fonts, cyberpunk-update, cyberpunk-dashboard --watch [seconds], cyberpunk-voice, cyberpunk-restore"
echo "Optional voice: install the matching Termux:API Android app, then run: pkg install termux-api"
echo "Termux appearance changes take effect after restarting the session."
