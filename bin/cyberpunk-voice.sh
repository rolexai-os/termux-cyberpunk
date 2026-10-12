#!/data/data/com.termux/files/usr/bin/bash
set -u
CONFIG="$HOME/.config/termux-cyberpunk/config"
[ -f "$CONFIG" ] && . "$CONFIG"
GREETING="${CYBERPUNK_VOICE_GREETING:-Good evening. All systems are online. How may I assist you?}"
PITCH="${CYBERPUNK_VOICE_PITCH:-0.82}"
RATE="${CYBERPUNK_VOICE_RATE:-0.90}"
STYLE="${CYBERPUNK_VOICE_STYLE:-cinematic}"
case "$STYLE" in
  cinematic) PITCH="${CYBERPUNK_VOICE_PITCH:-0.82}"; RATE="${CYBERPUNK_VOICE_RATE:-0.90}" ;;
  balanced) PITCH="${CYBERPUNK_VOICE_PITCH:-0.96}"; RATE="${CYBERPUNK_VOICE_RATE:-1.00}" ;;
  crisp) PITCH="${CYBERPUNK_VOICE_PITCH:-0.92}"; RATE="${CYBERPUNK_VOICE_RATE:-1.08}" ;;
  *) echo "Unknown voice profile '$STYLE'; use cinematic, balanced, or crisp." >&2; exit 2 ;;
esac
if ! command -v termux-tts-speak >/dev/null 2>&1; then
  echo "Voice unavailable: termux-tts-speak was not found."
  echo "Install the Termux:API Android app from the same source as Termux, then run: pkg install termux-api"
  exit 1
fi
case "$PITCH:$RATE" in
  *[!0-9.:]*|:*|*:) echo "Invalid pitch/rate in $CONFIG; use numeric values such as 0.82 and 0.90." >&2; exit 2 ;;
esac
echo "Voice profile: $STYLE (pitch $PITCH, rate $RATE)"
echo "Note: voice timbre depends on your Android TTS engine and selected voice."
if termux-tts-speak -p "$PITCH" -r "$RATE" "$GREETING"; then exit 0; else
  echo "Text-to-speech failed. Check Android TTS engine, Termux:API app, and permissions." >&2
  exit 1
fi
