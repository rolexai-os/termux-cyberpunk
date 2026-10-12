#!/data/data/com.termux/files/usr/bin/bash
set -u
if command -v termux-tts-speak >/dev/null 2>&1; then
  termux-tts-speak "Cyberpunk terminal online. Systems ready."
else
  echo "Voice unavailable. Install the Termux:API app matching your Termux source, then run:"
  echo "  pkg install termux-api"
fi
