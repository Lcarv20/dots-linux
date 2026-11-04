# dots-linux 🐧

Fedora Server/Minimal → a complete **Wayland + Niri + Dux Shell** desktop,
managed with **GNU Stow** and installed by a single interactive TUI.

## 🚀 Quick start (Fedora Server / Minimal VM)

Boot a fresh Fedora Server (or Minimal) install — yes, the console-only one —
then:

```bash
git clone https://github.com/Lcarv20/dots-linux ~/dots-linux
cd ~/dots-linux
./install
```

The installer detects your hardware (iMac18,3 vs VM vs generic), shows a plan
(gum TUI), and runs the stages. Reboot when it finishes → you land in
**greetd → dms-greeter → Niri**.

Non-interactive / unattended:

```bash
./install --yes --profile=full        # everything, no prompts
./install --host=vm --profile=minimal # force the VM profile
```

Rehearse safely first (prints every action, changes nothing):

```bash
./install --dry-run
```

### Options

| Flag | Meaning |
|------|---------|
| `--help` | Usage + stage list |
| `--dry-run` | Show all actions without executing them |
| `--yes` | Non-interactive; accept defaults |
| `--profile=minimal\|full\|custom` | `minimal` = complete desktop, `full` = + extras (Chrome, runtimes, Flathub), `custom` = pick stages |
| `--host=auto\|imac18-3\|vm\|none` | Hardware profile (`auto` via DMI + `systemd-detect-virt`) |
| `--with-extras` | Add the extras stage (60) to any profile |
| `--with-mango` | Also stow the `mango` package |

## 🧩 How it works

```
manifest/   package lists (copr · dnf-core · dnf-extras · flatpak · mise)
stages/     00-repos        RPM Fusion, Terra, COPRs
            10-desktop-base dnf core (Wayland/audio/portals/fonts), mise, zsh
            20-niri-dms     verify niri/dms stack, drop legacy ~/.local/bin
            30-assets       wallpapers, icons, fonts, dfiles-shell (+patches), bin
            40-dotfiles     stow --no-folding (conflicts → ~/.dots-backup-<ts>/)
            50-services     chrome policy dir, greetd, DMs, systemd user units
            60-extras       Chrome repo, mise runtimes, Flathub, udev (--with-extras)
            90-hardware     host quirks via hosts/<profile>/apply.sh
system/     root-owned files: greetd config + niri greeter configs, udev,
            dfiles-shell patcher
hosts/      imac18-3 (kernel args, BT resume rescue, DKMS audio, 5K outputs)
            vm      (guest agents, auto-detected outputs)
```

Everything logs to `setup.log` (gitignored). Every stage is idempotent —
re-run `./install` after a partial failure without fear.

### Host profiles

- **imac18-3** — `mem_sleep_default=s2idle acpi_osi=!Darwin acpi_backlight=video
  video=eDP-1:5120x2880MR@60e` kernel args, the `bt-resume-rescue` suspend
  drop-in (Bluetooth keyboard/trackpad wakeup race), DKMS `snd_hda_macbookpro`
  audio, `eDP-1` 3840×2160 @ 1.25 scale outputs, greeter cursor JuxCursor 37.
- **vm** — `qemu-guest-agent` + `spice-vdagent` (in QEMU/KVM), no hardcoded
  output modes, greeter cursor JuxCursor 32.

### Stowed packages

fastfetch · ghostty · git · lazygit · lsd · nvim · starship · zed · zsh ·
niri · dms · portals · environment · systemd-user · scripts ·
desktop-tools (· mango with `--with-mango`)

| Tool | Config path |
|------|-------------|
| Niri | `~/.config/niri` |
| Dux Shell (dms) | `~/.config/dms` |
| Ghostty | `~/.config/ghostty` |
| Zsh | `~/.zshrc`, `~/.zsh_plugins.txt` |
| Neovim | `~/.config/nvim` |
| Zed | `~/.config/zed` |
| Starship | `~/.config/starship.toml` |
| Fastfetch | `~/.config/fastfetch` |
| Lazygit | `~/.config/lazygit` |
| LSD | `~/.config/lsd` |
| Git | `~/.config/git` |

Stow manually with: `stow --dir=~/dots-linux --target=~ --no-folding <pkg>`

## 🛠 Notes

- Requires `sudo`; run `./install` as your normal user (never as root).
- After a **dux-files RPM upgrade**, re-apply the shell patches:
  `system/dfiles-patch/apply-dfiles-patch.sh --refresh`
- AI agents working in this repo: read [`AGENTS.md`](AGENTS.md) first —
  never overwrite symlinks blindly, never commit secrets/runtime state, and
  log fundamental OS changes in `~/Agentic-linux.md` (portable vs
  iMac18,3-only).

## ⌨️ Keybindings (macOS → Linux)

- **General:** macOS `Cmd` is translated to `Ctrl` in most configs.
- **Zed:** `Ctrl-q` to close tabs (avoids the `Ctrl-w` delay).
- **Neovim:** macOS `<D-` bindings are converted to `<C-`.
