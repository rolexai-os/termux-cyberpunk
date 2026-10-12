#!/data/data/com.termux/files/usr/bin/bash
set -u
CONFIG="$HOME/.config/termux-cyberpunk/config"
[ -f "$CONFIG" ] && . "$CONFIG"
GREEN=$'\033[1;32m'; CYAN=$'\033[1;36m'; DIM=$'\033[2;32m'; RESET=$'\033[0m'
clear 2>/dev/null || true
printf '%s' "$CYAN"
cat <<'ART'
   ______      __                 __
  / ____/_  __/ /_  ___  ______  / /____  ____  __ __
 / /   / / / / __ \/ _ \/ ___/ / __/ _ \/ __ \/ // /
/ /___/ /_/ / /_/ /  __/ /    / /_/  __/ / / / , <
\____/\__, /_.___/\___/_/     \__/\___/_/ /_/_/|_|
     /____/
ART
printf '%s  C Y B E R P U N K   T E R M U X%s\n' "$GREEN" "$RESET"
if [ "${CYBERPUNK_ANIMATION:-1}" = "1" ]; then
  printf '%s' "$DIM"
  for frame in 'INITIALIZING NEURAL LINK' 'LOADING TERMINAL MODULES' 'SYSTEM READY'; do
    printf '\r[+] %-30s' "$frame"
    sleep 0.18
  done
  printf '\n%s' "$RESET"
fi
