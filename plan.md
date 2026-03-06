# Linux Dotfiles Migration & Automation Plan

This plan outlines the final steps for the `dots-linux` repository: installing **Ghostty**, migrating missing tool configs (**Gemini**, **OpenCode**, **Vibe**), and creating a **Linux-specific `setup` script** for automation.

## 1. Ghostty Installation & Migration ✅
- [x] **Install Ghostty**: Community `.deb` repository by Mike Kasberg.
- [x] **Migrate Config**:
    - [x] Ported `ghostty/config` to `dots-linux/ghostty/.config/ghostty/config`.
    - [x] **Audit Config**:
        - [x] Remove macOS-specific fonts.
        - [x] Set font to `MonaspiceKr Nerd Font`.

## 2. Neovim & Development Tools ✅
- [x] **Neovim (nvim)**: 
    - [x] Ported `nvim` config from macOS.
    - [x] **Keymap Audit**: Replaced macOS `<D-` (Cmd) with `<C-` (Ctrl) and Alt combinations.
    - [x] **Default Config**: Linked to `~/.config/nvim/` (no more `mvim` alias).
    - [x] **Upgrade**: Using Neovim 0.11.6 via `mise`.

## 3. Terminal Adaptation ✅
- [x] **Remove Alacritty**: Uninstalled and removed from dots.
- [x] **Install WezTerm**: Official APT repository.
- [x] **Install Rio**: Flatpak (v0.2.37).
- [x] **Configs**: Stowed to `~/.config/wezterm` and `~/.config/rio`.
    - [x] **Themes**: Gruvbox Dark Hard (matches Alacritty).
    - [x] **Opacity**: 0.95 with blur.
    - [x] **Shortcuts**: `Ctrl-Q` to close tabs/windows (consistency).

## 4. Missing Tools Migration ✅
- [x] **Gemini**: Migrated `.gemini` folder to `dots-linux/gemini/`.
- [x] **OpenCode**: Migrated `.config/opencode` to `dots-linux/opencode/.config/`.
- [x] **Vibe**: Migrated `.vibe` folder to `dots-linux/vibe/`.
- [x] **Fastfetch**:
    - [x] Installed via `mise`.
    - [x] Stowed config from `dots-macos`.

## 5. Automation & Documentation ✅
- [x] **Port macOS Script**:
    - [x] Created `dots-linux/setup` with spinner, logging, and two-column UI.
    - [x] Translated for `apt` and `mise`.
- [x] **Documentation**: Created `dots-linux/README.md`.

---

### Step-by-Step Execution
1.  **Ghostty Repo**: ✅ Done.
2.  **Scripting**: ✅ Done.
3.  **Documentation**: ✅ Done.
4.  **Final Stow**: ✅ Done.
