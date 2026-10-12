# Termux Cyberpunk Theme

A lightweight, reversible terminal customization toolkit for Termux on Android 12+. No root access required.

## Features

- Cyberpunk neon palette plus seven selectable presets: Matrix, Dracula, Nord, Gruvbox, Solarized Dark, Monokai and Synthwave
- Safe theme switching with timestamped backups of your previous palette
- Banner styles: built-in Cyberpunk, Matrix, compact, FIGlet, TOIlet and optional rainbow output with lolcat
- Font manager for local TrueType fonts, with backup, restore and reset commands
- Font-family collection guide for JetBrains Mono, Fira Code, Hack, Ubuntu Mono, Source Code Pro, Iosevka and MesloLGS NF
- Device, Android version, date/time, uptime, memory, storage, and optional battery dashboard
- Optional spoken greeting through Termux:API, with configurable greeting text
- Interactive manager and one-command GitHub updater
- Backup-aware installer and conservative restore/uninstall
- Dashboard refresh mode: \`cyberpunk-dashboard --watch [seconds]\`
- Bash syntax checks and automated tests through GitHub Actions

## Requirements

- Current supported Termux build
- Bash, coreutils and procps (installer installs/checks these using \`pkg\`)
- Optional banner tools: FIGlet, TOIlet and lolcat. Installer attempts to install them; built-in banners still work if unavailable.
- Optional voice: install the Termux:API Android app from the same source/signing family as Termux, then run \`pkg install termux-api\`
- Voice uses Android's configured text-to-speech engine; it does not install a voice engine itself

## Install

Run inside Termux:

\`\`\`bash
pkg update
pkg install -y git
git clone https://github.com/rolexai-os/termux-cyberpunk.git
cd termux-cyberpunk
bash install.sh
\`\`\`

Restart the Termux session after installation.

## Update from the Termux terminal

After the first install of this version, use the built-in updater:

\`\`\`bash
cyberpunk-update
\`\`\`

It fast-forwards the saved Git checkout from \`origin/main\`, then reruns the installer. It refuses to force-reset a divergent checkout. You can also update manually from the repository directory:

\`\`\`bash
git pull --ff-only origin main
bash install.sh
\`\`\`

## Commands

\`\`\`bash
cyberpunk                         # Banner + one-shot dashboard
cyberpunk-manager                 # Interactive menu
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
cyberpunk-voice                   # Speak configured greeting
cyberpunk-restore                 # Restore theme configuration and uninstall commands
\`\`\`

### Color themes

Presets are stored under \`config/themes/\` in the repository and copied to \`~/.local/share/termux-cyberpunk/themes/\` during install. Available names:

- \`cyberpunk\` — dark background, neon green and cyan
- \`matrix\` — green-on-black
- \`dracula\` — purple, pink and cyan accents
- \`nord\` — cool blue-gray
- \`gruvbox\` — warm retro colors
- \`solarized-dark\` — low-contrast dark palette
- \`monokai\` — classic coding palette
- \`synthwave\` — magenta/cyan retro neon

Every theme switch saves the previous \`~/.termux/colors.properties\` under \`~/.local/share/termux-cyberpunk/theme-backups/\`. Run \`termux-reload-settings\` when available; restart Termux if colors do not refresh.

### Banner and FIGlet customization

The \`cyberpunk-art\` command accepts a style followed by the text to display. The \`figlet\`, \`toilet\` and \`rainbow\` styles need their corresponding optional packages. For example:

\`\`\`bash
pkg install figlet toilet lolcat
cyberpunk-art figlet "ROLEX AI"
cyberpunk-art toilet "JARVIS"
cyberpunk-art rainbow "SYSTEM ONLINE"
\`\`\`

These tools only print terminal art; they do not change device security settings or require root.

### Fonts

Termux uses a custom font file at \`~/.termux/font.ttf\`. \`cyberpunk-fonts install /path/to/font.ttf\` backs up the existing custom font before copying the selected local TrueType file. Font files are not bundled into this repository; this avoids shipping unverified font binaries and keeps the repository lightweight.

For a curated font collection, install the official [Termux:Styling add-on](https://github.com/termux/termux-styling), then long-press the terminal, choose **More → Style → Choose font**. Explore JetBrains Mono, Fira Code, Hack, Ubuntu Mono, Source Code Pro, Iosevka and MesloLGS NF when offered by your chosen font source. Verify licensing and download fonts only from trusted sources. After manually installing a font, restart Termux.

## Settings

Edit \`~/.config/termux-cyberpunk/config\`:

\`\`\`bash
CYBERPUNK_ANIMATION=1
CYBERPUNK_AUTO_VOICE=0
CYBERPUNK_VOICE_GREETING="Cyberpunk terminal online. Systems ready."
\`\`\`

- \`CYBERPUNK_ANIMATION=0\` disables the short banner animation.
- \`CYBERPUNK_AUTO_VOICE=1\` speaks on each \`cyberpunk\` command invocation.
- \`CYBERPUNK_VOICE_GREETING\` sets the text passed to Android text-to-speech.
- Use \`cyberpunk-manager\` to change settings without manually editing the config.

## Backups and restore safety

- The installer backs up \`.bashrc\`, \`~/.termux/colors.properties\`, and \`~/.termux/termux.properties\` before changing them.
- It records the theme-installed copies of the two Termux property files.
- Restore removes only the marked Cyberpunk block from \`.bashrc\`; unrelated shell edits are preserved.
- If a property file differs from the theme-installed snapshot, restore preserves it instead of overwriting user edits.
- Theme and font changes create their own timestamped backups.
- Backups and settings are retained under \`~/.local/share/termux-cyberpunk/\` and \`~/.config/termux-cyberpunk/\`. The first known pre-theme state is retained in \`backups/original\`; later installs create timestamped snapshots.

## Testing

Run inside a Bash environment:

\`\`\`bash
bash tests/test_scripts.sh
\`\`\`

The test suite checks Bash syntax and static feature markers without requiring Android APIs. GitHub Actions runs it on pushes and pull requests. Battery, font rendering and voice behavior must still be tested on an actual Android/Termux device.

## Troubleshooting

- **Colors did not change:** run \`termux-reload-settings\` or restart Termux.
- **FIGlet/TOIlet command missing:** run \`pkg install figlet toilet\`; built-in art still works without these tools.
- **Font file cannot be found:** move the downloaded \`.ttf\` into Termux-accessible storage and pass its actual path to \`cyberpunk-fonts install\`.
- **Voice is unavailable:** install the Termux:API app from the same source as Termux, run \`pkg install termux-api\`, and verify an Android TTS engine is enabled.
- **Battery details are missing:** grant Termux:API permissions if requested; the rest of the dashboard remains usable.
- **Restore preserves a file:** this is intentional when the file changed after installation. Review it manually before replacing it with a backup.

## Uninstall

Run:

\`\`\`bash
cyberpunk-restore
\`\`\`

It removes installed commands and the managed \`.bashrc\` block, and restores property files only when safe. Review retained backups before deleting \`~/.local/share/termux-cyberpunk/\`.

## License

MIT
