# Termux Cyberpunk Theme

A lightweight, reversible Cyberpunk terminal customization for Termux on Android 12+.
Designed for phones such as the Xiaomi Mi 10i. No root access required.

## Features
- Black background with neon green/cyan terminal palette
- Cyberpunk ASCII banner and short startup animation
- Battery, storage, memory and device dashboard
- Optional voice greeting through Termux:API
- Theme manager commands: `cyberpunk`, `cyberpunk-dashboard`, `cyberpunk-voice`, `cyberpunk-restore`
- Automatic backups before changing existing configuration

## Requirements
- Termux (recommended: current supported build)
- `bash`, `git`, `coreutils`, `procps` (installed by setup)
- Optional voice: install the **Termux:API Android app from the same source/signing family as Termux**, then run `pkg install termux-api`.
- Voice uses Android text-to-speech via `termux-tts-speak`; it does not install a voice engine itself.

## Install from GitHub
Run in Termux:

```bash
pkg update
pkg install git
 git clone https://github.com/rolexai-os/termux-cyberpunk.git
cd termux-cyberpunk
bash install.sh
```

You can also copy the project folder into Termux and run `bash install.sh`.

## Commands
```bash
cyberpunk              # Show banner and dashboard
cyberpunk-dashboard    # Refresh system dashboard
cyberpunk-voice        # Test optional voice greeting
cyberpunk-restore      # Restore the files backed up by the installer
```

## Notes
- Installer backs up `~/.bashrc`, `~/.termux/colors.properties`, and `~/.termux/termux.properties` before modifying them.
- It adds a small source line to `~/.bashrc`; it does not replace your existing shell configuration.
- Startup animation is short and can be disabled by setting `CYBERPUNK_ANIMATION=0` in `~/.config/termux-cyberpunk/config`.
- Voice is opt-in on every startup by default; enable automatic voice with `CYBERPUNK_AUTO_VOICE=1` in that config file.
- `termux-battery-status` needs the Termux:API app and its matching Termux package. If unavailable, dashboard gracefully skips battery details.
- To avoid Android 12+ killing long-running processes, the startup animation is brief and no background loops are started.

## Uninstall / restore
Run:
```bash
cyberpunk-restore
```
This restores the latest installer backup if present. Review `~/.bashrc` if you had other edits after installation. Backups are stored in `~/.local/share/termux-cyberpunk/backups/`.

## License
MIT
