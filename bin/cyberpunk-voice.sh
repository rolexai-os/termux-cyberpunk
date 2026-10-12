#!/data/data/com.termux/files/usr/bin/bash
set -u
CONFIG="$HOME/.config/termux-cyberpunk/config"
[ -f "$CONFIG" ] && . "$CONFIG"
GREETING="${CYBERPUNK_VOICE_GREETING:-Cyberpunk terminal online. Systems ready.}"
if ! command -v termux-tts-speak >/dev/null 2>&1; then
  echo "Voice unavailable: termux-tts-speak was not found."
  echo "Install the Termux:API Android app from the same source as Termux, then run: pkg install termux-api"
  exit 1
fi
if termux-tts-speak "$GREETING"; then exit 0; else
  echo "Text-to-speech failed. Check Android TTS engine, Termux:API app, and permissions." >&2
  exit 1
fi
