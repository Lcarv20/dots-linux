# AGENTS.md — instructions for AI coding agents

This file is binding for **all** AI agents working in this repository
(Antigravity, OpenCode, Cursor, Claude, …). Read it before touching anything.

## What this repo is

`dots-linux` holds **portable dev-tool dotfiles only**: fastfetch, ghostty,
git, lazygit, lsd, nvim, starship, zed, zsh — stowed with GNU Stow and
bootstrapped by `./setup` (auto-detects Fedora vs Debian-family via
`/etc/os-release`). It is intentionally **free of desktop-environment
configs**: niri, dux shell (dms), greetd, portals, and host quirks live in
the separate `~/env-linux` repo, so this repo can be carried to any Linux
machine regardless of desktop.

```
setup                Distro-auto-detecting bootstrap (dnf/apt + mise + stow)
<stow packages>/     fastfetch, ghostty, git, lazygit, lsd, nvim,
                     starship, zed, zsh
```

## Golden rules

1. **Never overwrite symlinks blindly.** Files in `~/.config` (and `~` in
   general) are symlinks into **both** this repo (dev tools) and
   `~/env-linux` (environment). Before editing anything under `$HOME`:
   - `ls -la` the path. If it is a symlink, **edit the repo file it points
     to**, not the symlink in place, and never delete/recreate the symlink
     by hand. `readlink -f` is your friend.
   - If a `$HOME` path is a *real file* while a stow package provides one,
     that is a conflict — resolve it in the repo or via the backup flow in
     `setup` (`~/.dots-backup-<timestamp>/`).

2. **Do not commit secrets or runtime state.** Never `git add`: `setup.log*`,
   caches, `*.log`, tokens, cookies, machine IDs. If a config needs a
   secret, template it and gitignore the concrete instance.

3. **Log fundamental OS changes in `~/Agentic-linux.md`** (date, symptom,
   root cause, exact fix, portable vs iMac18,3-only). Restructures of this
   repo or its symlink farm must also be logged there.

4. **The zsh package is load-bearing.** `.zshrc` evals mise, zoxide,
   direnv, fzf, starship — all installed by `setup`. Keep the section
   structure (paths → antidote → integrations → aliases) and the defensive
   ZLE reset; past recursion bugs live in git history — read before
   refactoring.

5. **Tool provenance is a contract.** CLI tools come from **mise**
   (`lsd lazygit fzf starship zoxide bat direnv neovim delta`), not from
   dnf/apt, so versions stay identical across distros. System packages are
   limited to build/base tooling, ghostty and fastfetch. Change this only
   with a good reason, in `setup`, keeping both package managers in sync.

6. **Idempotency is required.** `setup` must be safe to re-run on any
   machine at any time: guard with `have`, back up conflicts, never assume
   a fresh machine.

## Useful commands

```bash
./setup --dry-run          # full rehearsal, zero changes
bash -n setup              # syntax check
shellcheck setup           # lint (if available)
stow --dir=~/dots-linux --target=~ --no-folding -S <pkg>    # stow manually
stow --dir=~/dots-linux --target=~ --no-folding -D <pkg>    # unstow manually
```
