#!/data/data/com.termux/files/usr/bin/bash
set -u
G=$'\033[1;32m'; C=$'\033[1;36m'; R=$'\033[0m'
CONFIG="$HOME/.config/termux-cyberpunk/config"
[ -f "$CONFIG" ] && . "$CONFIG"
line() { printf '%s------------------------------------------------%s\n' "$C" "$R"; }
read_device() {
  local value=""
  if [ -n "${ANDROID_PRODUCT:-}" ]; then value="$ANDROID_PRODUCT"
  elif [ -n "${MODEL:-}" ]; then value="$MODEL"
  elif command -v getprop >/dev/null 2>&1; then value="$(getprop ro.product.model 2>/dev/null)"
  fi
  printf '%s' "${value:-Android device (model unavailable)}"
}
show_dashboard() {
  line
  printf '%s  CYBERPUNK // SYSTEM STATUS%s\n' "$G" "$R"
  line
  printf '%sDevice:%s %s\n' "$C" "$R" "$(read_device)"
  printf '%sAndroid:%s %s\n' "$C" "$R" "$(command -v getprop >/dev/null 2>&1 && getprop ro.build.version.release 2>/dev/null || printf 'unavailable')"
  printf '%sDate:%s   %s\n' "$C" "$R" "$(date '+%Y-%m-%d %H:%M:%S %Z' 2>/dev/null || echo unavailable)"
  printf '%sUptime:%s ' "$C" "$R"
  if command -v uptime >/dev/null 2>&1; then uptime 2>/dev/null | sed 's/^[[:space:]]*//' || echo unavailable; else echo "unavailable (install procps)"; fi
  printf '%sMemory:%s\n' "$C" "$R"
  if command -v free >/dev/null 2>&1; then free -h 2>/dev/null | head -n 2 || echo unavailable; else echo "unavailable (install procps)"; fi
  line
}
if [ "${1:-}" = "--watch" ] || [ "${1:-}" = "-w" ]; then
  interval="${2:-5}"
  case "$interval" in *[!0-9]*|"") echo "Usage: cyberpunk-dashboard --watch [seconds]" >&2; exit 2 ;; esac
  [ "$interval" -ge 2 ] || interval=2
  while :; do clear 2>/dev/null || true; show_dashboard; printf 'Refreshing every %s seconds. Press Ctrl+C to stop.\n' "$interval"; sleep "$interval"; done
else show_dashboard
fi
