# AGENTS.md — instructions for AI coding agents

This file is binding for **all** AI agents working in this repository
(Antigravity, OpenCode, Cursor, Claude, …). Read it before touching anything.

## What this repo is

`dots-linux` is a GNU Stow-managed dotfiles repo **plus** a modular installer
that turns a naked Fedora Server / Minimal install into a complete
**Wayland + Niri + Dux Shell** desktop:

```
install              Executable TUI entry point (gum-based, pure-bash fallback)
manifest/            Package lists: copr, dnf-core, dnf-extras, flatpak-extras,
                    mise-core, mise-extras — the single source of truth for
                    what gets installed. Want a package? Add it to a manifest.
stages/              Numbered installer stages (executed in order):
                      00-repos → 10-desktop-base → 20-niri-dms → 30-assets →
                      40-dotfiles → 50-services → 60-extras → 90-hardware
                    stages/lib.sh is the shared library (UI, logging, run_cmd).
system/              Root-owned files shipped by the repo (greetd config,
                    greeter niri configs, udev rules, dfiles-shell patcher).
hosts/               Per-host hardware quirks (imac18-3, vm) applied by
                    stages/90-hardware.sh → hosts/<profile>/apply.sh.
<stow packages>/     fastfetch, ghostty, git, lazygit, lsd, nvim, starship,
                    zed, zsh, niri, dms, portals, environment, systemd-user,
                    autostart, scripts, desktop-tools, mango, …
```

## Golden rules

1. **Never overwrite symlinks blindly.** Files in `~/.config` (and `~` in
   general) are symlinks into this repo — installed by `stow --no-folding`.
   Before editing anything under `$HOME`:
   - `ls -la` the path. If it is a symlink, **edit the repo file it points
     to**, not the symlink target in place, and never delete/recreate the
     symlink by hand. `readlink -f` is your friend.
   - If a `$HOME` path is a *real file* while a stow package provides one,
     that is a conflict — resolve it in the repo or via the installer's
     backup flow (stage 40 backs up to `~/.dots-backup-<timestamp>/`).

2. **Do not commit secrets or runtime state.** Never `git add`:
   `setup.log*`, caches (`~/.cache` mirrors), `*.log`, tokens, cookies,
   machine IDs, or anything under `gemini/.gemini/` except `settings.json`
   and `GEMINI.md` (see `.gitignore`). If a config file needs a secret,
   template it and gitignore the concrete instance.

3. **Log fundamental OS changes in `~/Agentic-linux.md`.** Any change to
   kernel args, systemd units, audio, sleep/suspend, display, Bluetooth,
   portals, udev or dotfiles must be logged there with: date, symptom,
   root cause, exact fix — and an explicit marker of scope:
   - **portable** (applies to any machine), or
   - **iMac18,3-only** (hardware quirk: 5K panel scaling, s2idle,
     `snd_hda_macbookpro` audio, BT resume race, Alpine Ridge xHCI).

4. **Don't touch packages another agent is stowing.** Stow packages may be
   created/mutated concurrently. Only edit files inside `install`,
   `AGENTS.md`, `README.md`, `manifest/`, `stages/`, `system/`, `hosts/`
   unless you have explicit instructions otherwise.

5. **Manifests are the source of truth.** Packages go into
   `manifest/*.txt` (one per line, `#` comments allowed) — never hardcode
   package lists inside stage scripts.

6. **All mutating commands go through `run_cmd`.** In `stages/*.sh` use the
   `run_cmd`/`install_file`/`copy_tree` helpers from `stages/lib.sh`; they
   log to `setup.log` and honor `DRY_RUN=true`. Test every stage change
   with: `DRY_RUN=true bash stages/<stage>.sh`

7. **Host quirks belong in `hosts/`.** Anything machine-specific (kernel
   args, DKMS modules, fixed output modes) lives in `hosts/<profile>/` and
   is selected via `HOST_PROFILE` / `--host=`. Keep everything else
   portable.

8. **Idempotency is required.** Every stage must be safe to re-run
   (the TUI re-runs stages after partial failures). Check before changing,
   use `--if-not-exists` / grep guards, never assume a fresh machine.

## Useful commands

```bash
./install --dry-run                 # full rehearsal, zero changes
DRY_RUN=true bash stages/40-dotfiles.sh   # rehearse one stage
bash hosts/imac18-3/apply.sh        # apply host quirks directly
system/dfiles-patch/apply-dfiles-patch.sh --refresh   # after dux-files RPM upgrade
```

## dfiles-shell patches (system/dfiles-patch/)

`~/.config/dfiles-shell` is patched after every install/refresh:
`Common/Theme.qml` (`launcherWidthLarge: 960`, `launcherHeightDefault: 700`)
and `Modules/ChooserWindow.qml` (Wayland title prefixed `"Dux Chooser · "`
so niri can float portal pickers). After a dux-files RPM upgrade run
`apply-dfiles-patch.sh --refresh` to re-copy from
`$XDG_RUNTIME_DIR/dfiles-shell/` and re-apply the patches.
