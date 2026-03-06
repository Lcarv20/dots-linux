alias v="/home/lcarv/.local/share/mise/installs/neovim/0.11.6/bin/nvim"
alias vim="/home/lcarv/.local/share/mise/installs/neovim/0.11.6/bin/nvim"
alias nvim="/home/lcarv/.local/share/mise/installs/neovim/0.11.6/bin/nvim"
export PATH="/home/lcarv/.local/share/mise/installs/neovim/0.11.6/bin:$PATH"
# --- DOTS-LINUX ZSHRC ---
# Managed with GNU Stow + Antidote

# 1. Antidote Setup
zsh_plugins=${ZDOTDIR:-$HOME}/.zsh_plugins.zsh
zsh_plugins_txt=${ZDOTDIR:-$HOME}/.zsh_plugins.txt

source /usr/share/zsh-antidote/antidote.zsh

if [[ ! $zsh_plugins -nt $zsh_plugins_txt ]]; then
  antidote bundle < $zsh_plugins_txt > $zsh_plugins
fi
source $zsh_plugins

# 2. Key Bindings & UI
autoload -Uz compinit && compinit
bindkey -v # Vi Mode
fpath+=~/.zfunc # Custom completions

# 3. Environment (Mise, Starship, Zoxide, Direnv, Fzf)
eval "$(mise activate zsh)"
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
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

# 6. Vi Mode Cursor (from macOS)
# (Ported from macOS config to handle Vi mode cursor shape)
zle-keymap-select() {
  if [[ ${KEYMAP} == vicmd ]]; then
    echo -ne "\e[1 q"
  else
    echo -ne "\e[5 q"
  fi
  zle reset-prompt
}
zle -N zle-keymap-select

zle-line-init() {
  zle -K viins
  echo -ne "\e[5 q"
}
zle -N zle-line-init

# 7. Poke-colorscript (if stowed)
if [ -f "$HOME/.local/bin/poke-colorscript" ]; then
    "$HOME/.local/bin/poke-colorscript"
fi
export PATH="/home/lcarv/.local/share/mise/installs/neovim/0.11.6/bin:$PATH"
