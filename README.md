# Linux Dotfiles 🐧

Custom development environment for Linux (Pop!_OS / Ubuntu), managed with **GNU Stow**.

## 🚀 Quick Start

1. **Clone the repository:**
   ```bash
   git clone <repo-url> ~/dots-linux
   cd ~/dots-linux
   ```

2. **Run the setup script:**
   ```bash
   ./setup
   ```
   *The script will install `apt` packages, `mise` tools, and `stow` your configuration files.*

## 📦 Managed Packages

| Tool | Config Path |
|------|-------------|
| **Alacritty** | `~/.config/alacritty` |
| **Ghostty** | `~/.config/ghostty` |
| **Zsh** | `~/.zshrc`, `~/.zsh_plugins.txt` |
| **Neovim** | `~/.config/nvim` |
| **Zed** | `~/.config/zed` |
| **Starship** | `~/.config/starship.toml` |
| **Fastfetch** | `~/.config/fastfetch` |
| **Lazygit** | `~/.config/lazygit` |
| **LSD** | `~/.config/lsd` |
| **Gemini** | `~/.gemini` |
| **OpenCode** | `~/.config/opencode` |
| **Vibe** | `~/.vibe` |

## 🛠 Prerequisites

The `setup` script handles most things, but it assumes you have:
- `sudo` privileges.
- `mise` installed (for CLI tool management).
- A Nerd Font installed (recommended: **MonaspiceNe Nerd Font**).

## ⌨️ Keybindings (Linux Adjustments)

- **General:** macOS `Cmd` is translated to `Ctrl` in most configs.
- **Zed:** `Ctrl-q` to close tabs (to avoid `Ctrl-w` delay).
- **Neovim:** macOS `<D-` bindings are converted to `<C-`.
