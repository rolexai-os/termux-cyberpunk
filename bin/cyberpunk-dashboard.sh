#!/data/data/com.termux/files/usr/bin/bash
set -u
G=$'\033[1;32m'; C=$'\033[1;36m'; Y=$'\033[1;33m'; R=$'\033[0m'
line() { printf '%s------------------------------------------------%s\n' "$C" "$R"; }
line
printf '%s  CYBERPUNK // SYSTEM STATUS%s\n' "$G" "$R"
line
printf '%sDevice:%s %s\n' "$C" "$R" "${ANDROID_PRODUCT:-${MODEL:-Android}}"
printf '%sDate:%s   %s\n' "$C" "$R" "$(date '+%Y-%m-%d %H:%M:%S %Z')"
printf '%sUptime:%s ' "$C" "$R"
uptime 2>/dev/null | sed 's/^[[:space:]]*//' || echo "unavailable"
printf '%sMemory:%s\n' "$C" "$R"
if command -v free >/dev/null 2>&1; then free -h | head -n 2; else echo "Install procps for memory details."; fi
printf '%sStorage:%s\n' "$C" "$R"
df -h "$HOME" 2>/dev/null | tail -n 1
if command -v termux-battery-status >/dev/null 2>&1; then
  echo "Battery:"
  termux-battery-status 2>/dev/null | grep -E '"(percentage|status|health|plugged|temperature)"' | sed 's/^/  /' || true
else
  printf '%sBattery:%s Optional: install Termux:API app and run pkg install termux-api\n' "$Y" "$R"
fi
line
