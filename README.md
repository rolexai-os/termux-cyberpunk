# Termux Cyberpunk Theme

A lightweight, reversible terminal customization toolkit for Termux on Android 12+. No root access required.

## Features

- Cyberpunk neon palette plus thirteen selectable presets: Matrix, Dracula, Nord, Gruvbox, Solarized Dark, Monokai, Synthwave, Ocean, Amber, Bloodmoon, Forest, Arctic, Vaporwave and Plasma Breeze
- Safe theme switching with timestamped backups of your previous palette
- Banner styles: built-in Cyberpunk, Matrix, compact, FIGlet, TOIlet and optional rainbow output with lolcat
- Font manager for local TrueType fonts, with backup, restore and reset commands
- Font-family collection guide for JetBrains Mono, Fira Code, Hack, Ubuntu Mono, Source Code Pro, Iosevka and MesloLGS NF
- Device, Android version, date/time, uptime and memory dashboard (storage and battery panels intentionally omitted)
- Cinematic AI-assistant voice profile with adjustable Android TTS pitch and rate (voice timbre depends on the installed Android TTS engine)
- Animated digital boot/loading screen and automatic banner/dashboard on interactive shell startup
- Clean settings manager with safe settings reset, theme-cache refresh and confirmed fresh reinstall
- Interactive manager and one-command GitHub updater
- Backup-aware installer and conservative restore/uninstall
- Dashboard refresh mode: `cyberpunk-dashboard --watch [seconds]`
- Live monitor for load, memory, top processes and network counters (storage/battery omitted)
- Local plugin manager with create, install, run, list and remove commands
- Manual settings backup and safe restore of Cyberpunk/Termux appearance files
- Optional one-shot speech shortcuts using Termux:API; only predefined actions are accepted
- Bash syntax checks and automated tests through GitHub Actions

## Requirements

- Current supported Termux build
- Bash, coreutils and procps (installer installs/checks these using `pkg`)
- Optional banner tools: FIGlet, TOIlet and lolcat. Installer attempts to install them; built-in banners still work if unavailable.
- Optional voice: install the Termux:API Android app from the same source/signing family as Termux, then run `pkg install termux-api`
- Voice uses Android's configured text-to-speech engine; it does not install a voice engine itself

## Install

Run inside Termux:

```bash
pkg update
pkg install -y git
git clone https://github.com/rolexai-os/termux-cyberpunk.git
cd termux-cyberpunk
bash install.sh
```

Restart the Termux session after installation.

## Update from the Termux terminal

After the first install of this version, use the built-in updater:

```bash
cyberpunk-update
```

It fast-forwards the saved Git checkout from `origin/main`, then reruns the installer. It refuses to force-reset a divergent checkout. You can also update manually from the repository directory:

```bash
git pull --ff-only origin main
bash install.sh
```

## Commands

```bash
cyberpunk                         # Banner + one-shot dashboard
cyberpunk-manager                 # Clean interactive control center
cyberpunk-clean settings          # Back up and reset Cyberpunk settings
cyberpunk-clean themes            # Refresh only Cyberpunk's cached theme presets
cyberpunk-clean fresh             # Confirmed fresh reinstall with backups
cyberpunk-style --list            # List available color themes
cyberpunk-style matrix            # Apply Matrix Green palette
cyberpunk-style dracula           # Apply Dracula palette
cyberpunk-art --list              # List banner renderers
cyberpunk-art figlet "Hello Termux"
cyberpunk-art toilet "Cyberpunk"
cyberpunk-art rainbow "Welcome"
cyberpunk-fonts                   # Show font status and collection guide
cyberpunk-fonts install ~/storage/downloads/JetBrainsMono.ttf
cyberpunk-fonts backup            # Back up current custom font
cyberpunk-fonts restore           # Restore latest saved font
cyberpunk-fonts reset             # Remove custom font; use Termux default
cyberpunk-update                  # Pull latest main and reinstall
cyberpunk-dashboard               # One-shot system dashboard
cyberpunk-dashboard --watch 10    # Refresh every 10 seconds
cyberpunk-monitor --watch 3       # Live system and network monitor
cyberpunk-listen                  # One-shot spoken shortcuts (Termux:API required)
cyberpunk-plugins list            # Manage local shell plugins
cyberpunk-plugins create NAME     # Create a starter plugin
cyberpunk-backup create           # Back up current settings
cyberpunk-backup list             # List saved backups
cyberpunk-backup restore latest   # Restore newest backup after confirmation
cyberpunk-manager                 # Customize voice, theme, startup and more
cyberpunk-voice                   # Speak configured cinematic AI greeting
cyberpunk-restore                 # Restore theme configuration and uninstall commands
```

### Color themes

Presets are stored under `config/themes/` in the repository and copied to `~/.local/share/termux-cyberpunk/themes/` during install. Available names:

- `cyberpunk` — dark background, neon green and cyan
- `matrix` — green-on-black
- `dracula` — purple, pink and cyan accents
- `nord` — cool blue-gray
- `gruvbox` — warm retro colors
- `solarized-dark` — low-contrast dark palette
- `monokai` — classic coding palette
- `synthwave` — magenta/cyan retro neon
- `ocean` — deep blue and cyan
- `amber` — warm amber terminal
- `bloodmoon` — crimson and rose
- `forest` — green natural palette
- `arctic` — cool blue and ice
- `vaporwave` — pink, violet and cyan
- `plasma-breeze` — KDE Plasma-inspired dark blue-gray with Breeze cyan accents

Every theme switch saves the previous `~/.termux/colors.properties` under `~/.local/share/termux-cyberpunk/theme-backups/`. Run `termux-reload-settings` when available; restart Termux if colors do not refresh.

### Banner and FIGlet customization

The `cyberpunk-art` command accepts a style followed by the text to display. The `figlet`, `toilet` and `rainbow` styles need their corresponding optional packages. For example:

```bash
pkg install figlet toilet lolcat
cyberpunk-art figlet "ROLEX AI"
cyberpunk-art toilet "JARVIS"
cyberpunk-art rainbow "SYSTEM ONLINE"
```

These tools only print terminal art; they do not change device security settings or require root.

### Fonts

Termux uses a custom font file at `~/.termux/font.ttf`. `cyberpunk-fonts install /path/to/font.ttf` backs up the existing custom font before copying the selected local TrueType file. Font files are not bundled into this repository; this avoids shipping unverified font binaries and keeps the repository lightweight.

For a curated font collection, install the official [Termux:Styling add-on](https://github.com/termux/termux-styling), then long-press the terminal, choose **More → Style → Choose font**. Explore JetBrains Mono, Fira Code, Hack, Ubuntu Mono, Source Code Pro, Iosevka and MesloLGS NF when offered by your chosen font source. Verify licensing and download fonts only from trusted sources. After manually installing a font, restart Termux.

## Custom startup command

Use `cyberpunk-manager` and select **16) Set startup command/app** to run a command after the banner and dashboard when Termux starts. Examples include `htop`, `python`, or `cd ~/project && python app.py`. Leave the prompt empty to disable it. Startup commands run with your Termux user permissions, so only configure commands you trust.

## Settings

Edit `~/.config/termux-cyberpunk/config`:

```bash
CYBERPUNK_ANIMATION=1
CYBERPUNK_LOADING=1
CYBERPUNK_AUTO_START=1
CYBERPUNK_AUTO_VOICE=0
CYBERPUNK_VOICE_STYLE=cinematic
CYBERPUNK_VOICE_PITCH=0.82
CYBERPUNK_VOICE_RATE=0.90
CYBERPUNK_VOICE_GREETING="Good evening. All systems are online. How may I assist you?"
```

- `CYBERPUNK_LOADING=0` disables the digital boot animation.
- `CYBERPUNK_ANIMATION=0` disables the short banner animation.
- `CYBERPUNK_AUTO_START=0` disables the banner/dashboard on each new interactive shell; re-enable it in `cyberpunk-manager`.
- `CYBERPUNK_AUTO_VOICE=1` speaks the greeting on each `cyberpunk` command invocation.
- `CYBERPUNK_VOICE_STYLE` accepts `cinematic`, `balanced` or `crisp`; pitch and rate can also be adjusted.
- `CYBERPUNK_VOICE_GREETING` sets the text passed to Android text-to-speech.
- `CYBERPUNK_STARTUP_COMMAND` can run a command/app after the startup display; configure it in `cyberpunk-manager` (option 16). Only use commands you trust.
- Use `cyberpunk-manager` to change settings without manually editing the config.

### Cinematic assistant voice

The `cinematic` profile requests a lower pitch and slower delivery from Android TTS for an original futuristic-assistant sound; it does not clone Tony Stark, Robert Downey Jr., or any actor's voice. For a masculine voice, open Android **Settings → Text-to-speech output**, select an available male voice in your TTS engine, then install Termux:API from the same source/signing family as Termux and run `pkg install termux-api`. Test with `cyberpunk-voice`; use `cyberpunk-manager` option 17 for the setup tips. The available voices depend on the Android TTS engine and language packs.

### Clean settings and fresh install

- `cyberpunk-clean settings` backs up and resets this project's settings.
- `cyberpunk-clean themes` backs up and refreshes only Cyberpunk's cached theme presets.
- `cyberpunk-clean fresh` requires you to type `FRESH`, backs up current Termux palette/property files, resets Cyberpunk settings and reapplies the repository defaults before reinstalling.

These commands do **not** remove unrelated Android/Termux themes or apps. The fresh-install option is limited to this project and keeps backups so you can recover your previous settings.

## Backups and restore safety

- The installer backs up `.bashrc`, `~/.termux/colors.properties`, and `~/.termux/termux.properties` before changing them.
- It records the theme-installed copies of the two Termux property files.
- Restore removes only the marked Cyberpunk block from `.bashrc`; unrelated shell edits are preserved.
- If a property file differs from the theme-installed snapshot, restore preserves it instead of overwriting user edits.
- Theme and font changes create their own timestamped backups.
- Backups and settings are retained under `~/.local/share/termux-cyberpunk/` and `~/.config/termux-cyberpunk/`. The first known pre-theme state is retained in `backups/original`; later installs create timestamped snapshots.

## Testing

Run inside a Bash environment:

```bash
bash tests/test_scripts.sh
```

The test suite checks Bash syntax and static feature markers without requiring Android APIs. GitHub Actions runs it on pushes and pull requests. Battery, font rendering and voice behavior must still be tested on an actual Android/Termux device.

## Troubleshooting

- **Colors did not change:** run `termux-reload-settings` or restart Termux.
- **FIGlet/TOIlet command missing:** run `pkg install figlet toilet`; built-in art still works without these tools.
- **Font file cannot be found:** move the downloaded `.ttf` into Termux-accessible storage and pass its actual path to `cyberpunk-fonts install`.
- **Voice is unavailable:** install the Termux:API app from the same source as Termux, run `pkg install termux-api`, and verify an Android TTS engine is enabled.
- **Restore preserves a file:** this is intentional when the file changed after installation. Review it manually before replacing it with a backup.

## Uninstall

Run:

```bash
cyberpunk-restore
```

It removes installed commands and the managed `.bashrc` block, and restores property files only when safe. Review retained backups before deleting `~/.local/share/termux-cyberpunk/`.

## License

MIT


## Voice shortcuts

Install the Termux:API Android app from the same source/signing family as Termux, then run `pkg install termux-api`. Use `cyberpunk-listen` and speak one shortcut such as dashboard, monitor, themes, settings, voice, plugins, backup, update or cancel. Recognition availability depends on Android speech services. The command router only maps speech to predefined actions; it does not execute arbitrary recognized text as shell code.

## Plugins

Use `cyberpunk-plugins create my-plugin` to create a starter under `~/.local/share/termux-cyberpunk/plugins/`. Review plugin code before running it: shell plugins execute with your Termux user's permissions. Install only scripts you trust.

## Backups and restore

`cyberpunk-backup create` saves the Cyberpunk config, Termux color palette, Termux properties and optional custom font under `~/.local/share/termux-cyberpunk/manual-backups/`. Restore asks for confirmation and first creates a safety backup of the current state. Upgrades continue to preserve the existing config and customized terminal properties where possible.


### KDE Plasma-inspired Breeze palette

Apply the new terminal palette with:

```bash
cyberpunk-style plasma-breeze
```

This adds KDE's Breeze-inspired dark background, cool blue-gray surfaces, and cyan highlights to **Termux terminal colors**. It does not install or change a KDE Plasma desktop environment; the theme format here is Termux's `colors.properties`. The palette is inspired by KDE's Breeze scheme ([KDE Breeze project](https://github.com/KDE/breeze), [Konsole Breeze colors](https://github.com/KDE/konsole/blob/master/data/color-schemes/Breeze.colorscheme)).
