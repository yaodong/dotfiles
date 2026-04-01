# Path to oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"
DISABLE_AUTO_UPDATE="true"

plugins=(starship git zsh-interactive-cd)

source $ZSH/oh-my-zsh.sh

# alias
alias ls='eza -lh --group-directories-first --icons'
alias lsa='ls -a'
alias lt='eza --tree --level=2 --long --icons --git'
alias lta='lt -a'
alias n=nvim
alias vi=nvim
alias vim=nvim
alias tt='theme-toggle'

# Wrappers for CLI tools that need to change shell state
ticket() { local d; d=$(command ticket "$@") && [ -n "$d" ] && cd "$d"; }

# common configurations
export LC_ALL=en_US.utf-8
export LANG=en_US.utf-8

# enable zoxide
eval "$(zoxide init zsh)"

# enable auto suggestions
if command -v brew &>/dev/null && [ -f "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
  source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
elif [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
elif [ -f /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi
SAVEHIST=1000
HISTSIZE=999
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify
bindkey '^[[A' history-search-backward # arrow up
bindkey '^[[B' history-search-forward  # arrow down
bindkey '^I^I' autosuggest-accept      # tab + tab
bindkey '^[[Z' autosuggest-accept      # shift + tab

if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi
export PATH="$HOME/.npm-global/bin:$HOME/.local/bin:$PATH"

# Source machine-local overrides
[ -f "$HOME/.zshrc_local" ] && source "$HOME/.zshrc_local"

# use Tmux only if current term program is Apple Terminal
if [ "$TERM_PROGRAM" = 'Apple_Terminal' ] || [ "$TERM_PROGRAM" = 'ghostty' ]; then
  tmux has -t scratch &> /dev/null
  if [ $? -ne 0 ]; then
    tmux new -s scratch
  elif [ -z $TMUX ]; then
    tmux attach -t scratch
  fi
fi
