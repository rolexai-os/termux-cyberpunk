# Termux Cyberpunk Theme

A lightweight, reversible cyberpunk terminal customization for Termux on Android 12+. No root access required.

## Features

- Black background and neon green/cyan terminal palette
- Cyberpunk ASCII banner and short startup animation
- Device, Android version, date/time, uptime, memory, storage, and optional battery dashboard
- Optional spoken greeting through Termux:API, with configurable greeting text
- Interactive manager for common settings and actions
- Backup-aware installer and conservative restore/uninstall
- Dashboard refresh mode: \`cyberpunk-dashboard --watch [seconds]\`
- Shell syntax checks and automated tests through GitHub Actions

## Requirements

- Current supported Termux build
- Bash, coreutils, procps (the installer checks/installs these using \`pkg\`)
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

## Commands

\`\`\`bash
cyberpunk                         # Banner + one-shot dashboard
cyberpunk-manager                 # Interactive menu
cyberpunk-dashboard               # One-shot system dashboard
cyberpunk-dashboard --watch       # Refresh every 5 seconds
cyberpunk-dashboard --watch 10    # Refresh every 10 seconds
cyberpunk-voice                   # Speak configured greeting
cyberpunk-restore                 # Restore theme configuration and uninstall commands
\`\`\`

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
- Backups and settings are retained under \`~/.local/share/termux-cyberpunk/\` and \`~/.config/termux-cyberpunk/\`.
- Repeated installs create new timestamped backups. Keep the backup directory if you may want to recover older configurations.

## Testing

Run locally inside a Bash environment:

\`\`\`bash
bash tests/test_scripts.sh
\`\`\`

The test suite checks Bash syntax and core configuration behavior without requiring Android APIs. GitHub Actions runs it on pushes and pull requests. Battery and voice behavior must still be tested on an actual Android/Termux device.

## Troubleshooting

- **Colors or extra keys did not change:** fully restart the Termux session.
- **Voice is unavailable:** install the Termux:API app from the same source as Termux, run \`pkg install termux-api\`, and verify an Android TTS engine is enabled.
- **Battery details are missing:** grant Termux:API permissions if requested; the rest of the dashboard remains usable.
- **Memory or uptime is unavailable:** run \`pkg install procps\`.
- **Restore preserves a file:** this is intentional when the file changed after installation. Review it manually before replacing it with a backup.
- **Automatic startup:** disabled by default to keep shell startup fast. You can choose to add \`cyberpunk\` to the managed block in \`.bashrc\` yourself.

## Uninstall

Run:

\`\`\`bash
cyberpunk-restore
\`\`\`

It removes installed commands and the managed \`.bashrc\` block, and restores property files only when safe. Review retained backups before deleting \`~/.local/share/termux-cyberpunk/\`.

## License

MIT
