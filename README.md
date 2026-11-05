# dots-linux 🐧

Portable **dev-tool dotfiles** — the config you take to any Linux machine,
regardless of desktop environment. Managed with **GNU Stow**, installed by a
single distro-auto-detecting script (`setup`).

The desktop environment (Niri, Dux Shell, greetd, host quirks) lives
separately in `env-linux`.

## 🚀 Quick start

```bash
git clone https://github.com/Lcarv20/dots-linux ~/dots-linux
cd ~/dots-linux
./setup
```

The script detects your distro family via `/etc/os-release`
(**Fedora → dnf**, **Debian/Ubuntu → apt**), installs the toolchain, and
stows every package with `--no-folding`. It is idempotent — re-run freely.

```bash
./setup --dry-run        # rehearse: print every action, change nothing
./setup --yes            # unattended (CI / containers)
./setup --no-runtimes    # skip mise language runtimes
./setup --no-chsh        # keep the current login shell
./setup --log            # verbose output → setup.log
```

## 📦 What you get

| Tool | Source | Config path |
|---|---|---|
| zsh + antidote | system pkg + git clone | `~/.zshrc`, `~/.zsh_plugins.txt` |
| Neovim | mise | `~/.config/nvim` |
| Ghostty | COPR (Fedora) / upstream .deb (Debian) | `~/.config/ghostty` |
| Zed | zed.dev installer | `~/.config/zed` |
| Starship | mise *(p10k migration planned)* | `~/.config/starship.toml` |
| lsd, lazygit, fzf, zoxide, bat, direnv, delta | mise | `~/.config/{lsd,lazygit}` |
| fastfetch | system pkg (+ .deb fallback) | `~/.config/fastfetch` |
| git | system pkg | `~/.gitconfig` |
| runtimes (bun, node, go, rust, pnpm, lua) | mise | `~/.config/mise` |

System packages: `git stow curl make gcc unzip zsh` — everything else comes
from **mise**, which is why the same script works unchanged on Fedora and
Debian-family distros.

Stow manually with: `stow --dir=~/dots-linux --target=~ --no-folding <pkg>`

## 🛠 Notes

- Conflicting real files are backed up to `~/.dots-backup-<timestamp>/`
  before stowing; existing symlinks are left untouched (idempotent).
- Works as root or with sudo (containers/VMs welcome).
- AI agents working in this repo: read [`AGENTS.md`](AGENTS.md) first —
  never overwrite symlinks blindly, never commit secrets/runtime state.

## ⌨️ Keybindings (macOS → Linux)

- **General:** macOS `Cmd` is translated to `Ctrl` in most configs.
- **Zed:** `Ctrl-q` to close tabs (avoids the `Ctrl-w` delay).
- **Neovim:** macOS `<D-` bindings are converted to `<C-`.
