# Zap plugin manager
[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ] && source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"

# Plugins
plug "zsh-users/zsh-autosuggestions"
plug "zsh-users/zsh-syntax-highlighting"
plug "zsh-users/zsh-completions"
plug "zap-zsh/sudo"

# Completions — cached compinit (rebuild once per day)
autoload -U compinit
if [[ -f ~/.zcompdump(#qNmh+24) ]]; then
  compinit
else
  compinit -C
fi

# Cached CLI completions — regenerate when binary changes
_cache_completion() {
  local cmd=$1 cache_file="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/completions/_$1"
  local bin_path="${commands[$cmd]}"
  [[ -z "$bin_path" ]] && return
  if [[ ! -f "$cache_file" || "$bin_path" -nt "$cache_file" ]]; then
    mkdir -p "${cache_file:h}"
    "$cmd" completion zsh > "$cache_file" 2>/dev/null
  fi
  [[ -f "$cache_file" ]] && source "$cache_file"
}
_cache_completion kubectl
_cache_completion docker
_cache_completion temporal

if command -v tctl &>/dev/null; then
  autoload -U +X bashcompinit && bashcompinit
  local tctl_cache="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/completions/_tctl"
  if [[ ! -f "$tctl_cache" || "${commands[tctl]}" -nt "$tctl_cache" ]]; then
    mkdir -p "${tctl_cache:h}"
    tctl completion bash > "$tctl_cache" 2>/dev/null
  fi
  [[ -f "$tctl_cache" ]] && source "$tctl_cache"
fi

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
[ -d "/opt/homebrew/opt/openjdk/bin" ] && export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
[ -d "/usr/local/opt/openjdk/bin" ] && export PATH="/usr/local/opt/openjdk/bin:$PATH"
export PATH="$PATH:$HOME/.local/bin"
export PATH="/opt/homebrew/bin:$PATH"

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

# Starship prompt — cached init to avoid extra starship spawn
_starship_init="${XDG_CACHE_HOME:-$HOME/.cache}/starship/init.zsh"
if [[ ! -f "$_starship_init" || "${commands[starship]}" -nt "$_starship_init" ]]; then
  mkdir -p "${_starship_init:h}"
  starship init zsh > "$_starship_init"
fi
source "$_starship_init"

# Transient prompt: collapse previous prompts to a simple arrow
_starship_prompt=$PROMPT
_starship_rprompt=$RPROMPT

_tp_restore_prompt() {
  PROMPT=$_starship_prompt
  RPROMPT=$_starship_rprompt
}
precmd_functions+=(_tp_restore_prompt)

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
