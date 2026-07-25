setopt AUTO_CD
# --- DOTS-LINUX ZSHRC ---
# Managed with GNU Stow + Antidote

# Prevent Starship re-sourcing keymap recursion loop
unset __starship_preserved_zle_keymap_select 2>/dev/null

# 1. Antidote Setup

zsh_plugins=${ZDOTDIR:-$HOME}/.zsh_plugins.zsh
zsh_plugins_txt=${ZDOTDIR:-$HOME}/.zsh_plugins.txt

source ${ZDOTDIR:-$HOME}/.antidote/antidote.zsh

if [[ ! $zsh_plugins -nt $zsh_plugins_txt ]]; then
  antidote bundle < $zsh_plugins_txt > $zsh_plugins
fi
source $zsh_plugins

# 2. Key Bindings & UI
autoload -Uz compinit && compinit
fpath+=~/.zfunc # Custom completions


# 3. Environment (Zoxide, Direnv, Fzf)
eval "$(zoxide init zsh)"
eval "$(direnv hook zsh)"
eval "$(fzf --zsh)"


# 4. Aliases (Merged from macOS)
# Better ls
alias ls='lsd'
alias l='lsd -l'
alias lt='lsd --tree'
alias la='lsd -a'
alias ll='lsd -l'
alias lla='lsd -la'

# Neovim
alias v='nvim'
alias vim='nvim'
# (Using default config in ~/.config/nvim)

# Better cat
if command -v bat &> /dev/null; then
  alias cat='bat -pp'
  alias catt='bat'
fi

# Editor for commit messages
alias vscommit='GIT_EDITOR="code --wait" git commit'
alias zcommit='GIT_EDITOR="zed --wait" git commit'

# 5. Paths & Tooling
export PATH="$HOME/.local/bin:$PATH"
export PNPM_HOME="$HOME/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"
export EDITOR='nvim'
export XDG_CONFIG_HOME="$HOME/.config"
export NEXT_TELEMETRY_DISABLED=1


# 7. Aesthetic Color Banner
_show_color_banner() {
  local esc=$'\e'
  local rf="${esc}[31m" gf="${esc}[32m" yf="${esc}[33m" bf="${esc}[34m" reset="${esc}[0m"
  cat << EOF
${rf}    ${reset}   ${gf}    ${reset}   ${yf}    ${reset}   ${bf}    ${reset}
${rf}o.o ${reset}   ${gf} o.o${reset}   ${yf}o.o ${reset}   ${bf} o.o${reset}
EOF
}
_show_color_banner



# Added by Antigravity CLI installer
export PATH="/home/lcarv/.local/bin:$PATH"
