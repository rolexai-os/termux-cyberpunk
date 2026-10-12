#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
for required in config/colors.properties config/termux.properties bin/cyberpunk bin/cyberpunk-banner.sh bin/cyberpunk-dashboard.sh bin/cyberpunk-voice.sh bin/cyberpunk-manager bin/cyberpunk-restore; do
  [ -f "$ROOT/$required" ] || { echo "Missing project file: $required" >&2; exit 1; }
done
if ! command -v pkg >/dev/null 2>&1; then echo "This installer requires Termux's pkg command. Run it inside Termux." >&2; exit 1; fi
echo "Checking required Termux packages..."
pkg install -y bash coreutils procps
BACKUP_ROOT="$HOME/.local/share/termux-cyberpunk/backups"
mkdir -p "$BACKUP_ROOT"
BASELINE="$BACKUP_ROOT/original"
# Preserve the first known pre-theme backup across updates, while keeping per-run snapshots.
if [ ! -d "$BASELINE" ]; then
  mkdir -p "$BASELINE/installed"
  FIRST_EXISTING="$(find "$BACKUP_ROOT" -mindepth 1 -maxdepth 1 -type d ! -name original | sort | head -n 1)"
  if [ -n "$FIRST_EXISTING" ]; then
    for f in bashrc colors.properties termux.properties created-by-installer.txt; do [ ! -f "$FIRST_EXISTING/$f" ] || cp -p "$FIRST_EXISTING/$f" "$BASELINE/$f"; done
  else
    for pair in ".bashrc:bashrc" ".termux/colors.properties:colors.properties" ".termux/termux.properties:termux.properties"; do
      src="\${pair%%:*}"; name="\${pair##*:}"
      if [ -f "$HOME/$src" ]; then cp -p "$HOME/$src" "$BASELINE/$name"; else echo "$src" >> "$BASELINE/created-by-installer.txt"; fi
    done
  fi
fi
STAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP="$BACKUP_ROOT/$STAMP"
mkdir -p "$BACKUP/installed" "$HOME/.termux" "$HOME/.config/termux-cyberpunk" "$HOME/.local/bin" "$HOME/.local/share/termux-cyberpunk"
for pair in ".bashrc:bashrc" ".termux/colors.properties:colors.properties" ".termux/termux.properties:termux.properties"; do
  src="\${pair%%:*}"; name="\${pair##*:}"
  if [ -f "$HOME/$src" ]; then cp -p "$HOME/$src" "$BACKUP/$name"; fi
done
for f in ".bashrc" ".termux/colors.properties" ".termux/termux.properties"; do [ -e "$HOME/$f" ] || echo "$f" >> "$BACKUP/created-by-installer.txt"; done
cp "$ROOT/config/colors.properties" "$HOME/.termux/colors.properties"
cp "$ROOT/config/termux.properties" "$HOME/.termux/termux.properties"
for file in cyberpunk cyberpunk-banner.sh cyberpunk-dashboard.sh cyberpunk-voice.sh cyberpunk-dashboard cyberpunk-voice cyberpunk-manager cyberpunk-restore; do cp "$ROOT/bin/$file" "$HOME/.local/bin/$file"; done
chmod +x "$HOME"/.local/bin/cyberpunk "$HOME"/.local/bin/cyberpunk-* "$HOME"/.local/bin/cyberpunk-restore
if [ ! -f "$HOME/.config/termux-cyberpunk/config" ]; then
  cat > "$HOME/.config/termux-cyberpunk/config" <<'CFG'
# 1 enables the brief banner animation; 0 disables it.
CYBERPUNK_ANIMATION=1
# 1 speaks the greeting whenever the main command is run.
CYBERPUNK_AUTO_VOICE=0
# Customize the text spoken by Termux:API.
CYBERPUNK_VOICE_GREETING="Cyberpunk terminal online. Systems ready."
CFG
fi
for target in "$BACKUP" "$BASELINE"; do
  mkdir -p "$target/installed"
  cp "$HOME/.termux/colors.properties" "$target/installed/colors.properties"
  cp "$HOME/.termux/termux.properties" "$target/installed/termux.properties"
done
touch "$HOME/.bashrc"
if ! grep -Fq '# >>> termux-cyberpunk >>>' "$HOME/.bashrc"; then
cat >> "$HOME/.bashrc" <<'BASHRC'

# >>> termux-cyberpunk >>>
export PATH="$HOME/.local/bin:$PATH"
# Run cyberpunk manually, or uncomment below for automatic startup.
# cyberpunk
# <<< termux-cyberpunk <<<
BASHRC
fi
export PATH="$HOME/.local/bin:$PATH"
echo
echo "Cyberpunk theme installed."
echo "Backup: $BACKUP"
echo "Original baseline: $BASELINE"
echo "Commands: cyberpunk, cyberpunk-manager, cyberpunk-dashboard --watch [seconds], cyberpunk-voice, cyberpunk-restore"
echo "Optional voice: install the matching Termux:API Android app, then run: pkg install termux-api"
echo "Termux appearance changes take effect after restarting the session."
