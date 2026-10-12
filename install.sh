#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
STAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP="$HOME/.local/share/termux-cyberpunk/backups/$STAMP"
mkdir -p "$BACKUP" "$HOME/.termux" "$HOME/.config/termux-cyberpunk" "$HOME/.local/bin" "$HOME/.local/share/termux-cyberpunk"
for pair in ".bashrc:bashrc" ".termux/colors.properties:colors.properties" ".termux/termux.properties:termux.properties"; do
  src="${pair%%:*}"; name="${pair##*:}"
  if [ -f "$HOME/$src" ]; then cp -p "$HOME/$src" "$BACKUP/$name"; fi
done
# Record files that did not previously exist so restore can remove the new ones.
for f in ".bashrc" ".termux/colors.properties" ".termux/termux.properties"; do
  [ -e "$HOME/$f" ] || echo "$f" >> "$BACKUP/created-by-installer.txt"
done
cp "$ROOT/config/colors.properties" "$HOME/.termux/colors.properties"
cp "$ROOT/config/termux.properties" "$HOME/.termux/termux.properties"
cp "$ROOT/bin/cyberpunk-banner.sh" "$HOME/.local/bin/cyberpunk-banner.sh"
cp "$ROOT/bin/cyberpunk-dashboard.sh" "$HOME/.local/bin/cyberpunk-dashboard.sh"
cp "$ROOT/bin/cyberpunk-voice.sh" "$HOME/.local/bin/cyberpunk-voice.sh"
cp "$ROOT/bin/cyberpunk" "$HOME/.local/bin/cyberpunk"
cp "$ROOT/bin/cyberpunk-dashboard" "$HOME/.local/bin/cyberpunk-dashboard"
cp "$ROOT/bin/cyberpunk-voice" "$HOME/.local/bin/cyberpunk-voice"
cp "$ROOT/bin/cyberpunk-restore" "$HOME/.local/bin/cyberpunk-restore"
chmod +x "$HOME"/.local/bin/cyberpunk*
mkdir -p "$HOME/.config/termux-cyberpunk"
if [ ! -f "$HOME/.config/termux-cyberpunk/config" ]; then
  cat > "$HOME/.config/termux-cyberpunk/config" <<'CFG'
# Set CYBERPUNK_ANIMATION=0 to disable startup animation.
CYBERPUNK_ANIMATION=1
# Set to 1 only if you want a spoken greeting on every new shell.
CYBERPUNK_AUTO_VOICE=0
CFG
fi
# Preserve any existing .bashrc; append the integration only once.
touch "$HOME/.bashrc"
if ! grep -Fq '# >>> termux-cyberpunk >>>' "$HOME/.bashrc"; then
cat >> "$HOME/.bashrc" <<'BASHRC'

# >>> termux-cyberpunk >>>
export PATH="$HOME/.local/bin:$PATH"
# Uncomment the next line to show the dashboard automatically in every interactive shell:
# cyberpunk
# <<< termux-cyberpunk <<<
BASHRC
fi
# PATH for current install session and immediate commands.
export PATH="$HOME/.local/bin:$PATH"
echo
echo "Cyberpunk theme installed."
echo "Backup: $BACKUP"
echo "Next: restart Termux, then run: cyberpunk"
echo "For optional voice: install the matching Termux:API Android app, then pkg install termux-api"
echo "Termux color/properties changes take effect after restarting the Termux session."
