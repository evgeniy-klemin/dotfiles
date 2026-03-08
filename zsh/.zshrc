# Zap plugin manager
[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ] && source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"

# Plugins
plug "zsh-users/zsh-autosuggestions"
plug "zsh-users/zsh-syntax-highlighting"
plug "zsh-users/zsh-completions"
plug "zap-zsh/sudo"

# Completions
autoload -U compinit && compinit
command -v kubectl &>/dev/null && source <(kubectl completion zsh)
command -v docker &>/dev/null && source <(docker completion zsh)
command -v temporal &>/dev/null && source <(temporal completion zsh)
command -v tctl &>/dev/null && autoload -U +X bashcompinit && bashcompinit && source <(tctl completion zsh)

# Options
setopt correct              # auto-correct commands
setopt prompt_sp            # preserve partial line output
ZLE_RPROMPT_INDENT=0        # no right prompt indent
setopt auto_cd              # cd by typing directory name
setopt hist_ignore_all_dups # no duplicate history entries
setopt share_history        # share history between sessions
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

# Editor
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# PATH
export GOPATH="$HOME/projects/go"
export PATH="$GOPATH/bin:$PATH"
export GOPROXY="https://proxy.golang.org,direct"
export GOROOT="$(go env GOROOT 2>/dev/null)"
[ -d "/opt/homebrew/opt/openjdk/bin" ] && export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
[ -d "/usr/local/opt/openjdk/bin" ] && export PATH="/usr/local/opt/openjdk/bin:$PATH"
export PATH="$PATH:$HOME/.local/bin"

# LuaRocks (for neovim plugins like image.nvim)
export LUA_PATH="$HOME/.luarocks/share/lua/5.1/?.lua;$HOME/.luarocks/share/lua/5.1/?/init.lua;;"
export LUA_CPATH="$HOME/.luarocks/lib/lua/5.1/?.so;;"

# Aliases
alias python="python3"
alias icat='kitty +kitten icat'
alias ls='lsd'
alias l='ls -Ah'
alias ll='ls -lAh'
alias lt='ls --tree'
alias vim='nvim'
alias vimdiff='nvim -d'

# Git aliases
alias gs='git status -sb'
alias gl='git lg'
alias gpl='git pull'
alias gp='git push'
alias gd='git diff'
alias gdt='git difftool -t nvimdiff -y'

# Ranger: cd to last visited dir on exit
function rng {
    local IFS=$'\t\n'
    local tempfile="$(mktemp -t tmp.XXXXXX)"
    local ranger_cmd=(
        command
        ranger
        --cmd="map Q chain shell echo %d > '$tempfile'; quitall"
    )
    ${ranger_cmd[@]} "$@"
    if [[ -f "$tempfile" ]] && [[ "$(cat -- "$tempfile")" != "$(pwd)" ]]; then
        cd -- "$(cat "$tempfile")"; clear || return
    fi
    command rm -f -- "$tempfile" 2>/dev/null
}

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Starship prompt
eval "$(starship init zsh)"


# Transient prompt: collapse previous prompt, print duration if >= 3s
zmodload zsh/datetime
_tp_cmd_start=0

_tp_preexec() { _tp_cmd_start=$EPOCHREALTIME }

_tp_precmd() {
  if (( _tp_cmd_start > 0 )); then
    local ms=$(( (EPOCHREALTIME - _tp_cmd_start) * 1000 ))
    _tp_cmd_start=0
    if (( ms >= 3000 )); then
      print "$(starship module cmd_duration --cmd-duration=${ms%.*})"
    fi
  fi
  PROMPT='$(starship prompt)'
}

precmd_functions=(_tp_precmd $precmd_functions)
preexec_functions+=(_tp_preexec)

zle-line-finish() {
  PROMPT="%B%F{green}❯%f%b "
  RPROMPT="%F{242}%D{%H:%M:%S}%f"
  zle reset-prompt
  RPROMPT=""
}
zle -N zle-line-finish

# Redraw prompt on terminal resize
TRAPWINCH() { zle && zle reset-prompt }

# Local overrides (not tracked in dotfiles)
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
