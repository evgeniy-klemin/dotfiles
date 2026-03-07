# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

DEFAULT_USER="eklemin"

POWERLEVEL9K_INSTANT_PROMPT=off

# DISABLE_AUTO_UPDATE="true"
DISABLE_UPDATE_PROMPT="true"

export UPDATE_ZSH_DAYS=30
DISABLE_AUTO_TITLE="true"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
plugins=(
  git
  kubectl
  colored-man-pages
  colorize
  command-not-found
  copybuffer
  docker
  docker-compose
  golang
  # helm
  virtualenv
  yarn
  django
  sudo
  autoupdate
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

export GOROOT="/usr/local/go"
export GOPATH="$HOME/projects/go"
export PATH="$GOROOT/bin:$GOPATH/bin:$PATH"

alias python="python3"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
export PATH="/usr/local/opt/openjdk/bin:$PATH"

autoload -U compinit && compinit
command -v temporal &>/dev/null && source <(temporal completion zsh)
command -v tctl &>/dev/null && source <(tctl completion zsh)

# Aliases
alias icat='kitty +kitten icat'
alias ls='lsd'
alias l='ls -Ah'
alias ll='ls -lAh'
alias lt='ls --tree'
alias vim='nvim'
alias vimdiff='nvim -d'
# git aliases
alias gs='git status -sb'
alias gl='git lg'
alias gpl='git pull'
alias gp='git push'
alias gd='git diff'
alias gdt='git difftool -t nvimdiff -y'

precmd () {print -Pn "\e]0;%~\a"}

# Created by `pipx` on 2023-12-30 15:37:02
export PATH="$PATH:/Users/eklemin/.local/bin"

# ranger
function rng {
    local IFS=$'\t\n'
    local tempfile="$(mktemp -t tmp.XXXXXX)"
    local ranger_cmd=(
        command
        ranger
        --cmd="map Q chain shell echo %d > "$tempfile"; quitall"
    )
    ${ranger_cmd[@]} "$@"
    if [[ -f "$tempfile" ]] && [[ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]]; then
        cd -- "$(cat "$tempfile")"; clear || return
    fi
    command rm -f -- "$tempfile" 2>/dev/null
}

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Local overrides (not tracked in dotfiles)
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
