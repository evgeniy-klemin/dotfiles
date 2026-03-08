#!/bin/bash
set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

ok()   { echo -e "  ${GREEN}✓${NC} $1"; }
warn() { echo -e "  ${YELLOW}!${NC} $1"; }
fail() { echo -e "  ${RED}✗${NC} $1"; }
info() { echo -e "\n${GREEN}==>${NC} $1"; }

MISSING_BREW=()

check_brew_pkg() {
    local pkg=$1
    local name=${2:-$1}
    if command -v "$pkg" &>/dev/null; then
        ok "$name ($(command -v "$pkg"))"
    else
        fail "$name — not found"
        MISSING_BREW+=("$pkg")
    fi
}

# -------------------------------------------------------------------
info "Homebrew"
if command -v brew &>/dev/null; then
    ok "brew ($(brew --prefix))"
else
    fail "brew not found — install from https://brew.sh/"
    exit 1
fi

# -------------------------------------------------------------------
info "GNU Stow"
check_brew_pkg stow "GNU Stow"

# -------------------------------------------------------------------
info "Brew packages"
check_brew_pkg starship "starship (prompt)"
check_brew_pkg lsd "lsd (modern ls)"
check_brew_pkg fzf "fzf (fuzzy finder)"
check_brew_pkg ranger "ranger (file manager)"
check_brew_pkg nvim "neovim"
check_brew_pkg node "node.js"
check_brew_pkg rg "ripgrep"
check_brew_pkg convert "imagemagick"

if command -v luarocks &>/dev/null; then
    ok "luarocks ($(luarocks --version | head -1))"
else
    fail "luarocks — not found"
    MISSING_BREW+=(luarocks)
fi

if [ ${#MISSING_BREW[@]} -gt 0 ]; then
    info "Installing missing brew packages: ${MISSING_BREW[*]}"
    brew install "${MISSING_BREW[@]}"
fi

# -------------------------------------------------------------------
info "Zap (zsh plugin manager)"
ZAP_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/zap"
if [ -d "$ZAP_DIR" ]; then
    ok "zap ($ZAP_DIR)"
else
    warn "zap not found — installing"
    zsh -c 'source <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --branch release-v1 --keep'
fi

# -------------------------------------------------------------------
info "fzf shell integration"
if [ -f ~/.fzf.zsh ]; then
    ok "~/.fzf.zsh exists"
else
    warn "~/.fzf.zsh not found — generating"
    "$(brew --prefix)/opt/fzf/install" --key-bindings --completion --no-update-rc --no-bash --no-fish
fi

# -------------------------------------------------------------------
info "npm global packages"
if command -v tree-sitter &>/dev/null; then
    TS_VER=$(tree-sitter --version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
    ok "tree-sitter-cli ($TS_VER)"
else
    warn "tree-sitter-cli not found — installing"
    npm install -g tree-sitter-cli
fi

if npm list -g neovim &>/dev/null; then
    ok "neovim npm package"
else
    warn "neovim npm package not found — installing"
    npm install -g neovim
fi

# -------------------------------------------------------------------
info "Luarocks packages"
if luarocks show magick 2>/dev/null | grep -q "magick"; then
    ok "magick luarock"
else
    warn "magick luarock not found — installing"
    luarocks --lua-dir="$(brew --prefix luajit)" --local install magick
fi

# -------------------------------------------------------------------
info "Python provider for neovim"
NVIM_VENV="$HOME/.local/venv/nvim"
if [ -x "$NVIM_VENV/bin/python" ] && "$NVIM_VENV/bin/python" -c "import pynvim" 2>/dev/null; then
    ok "pynvim ($NVIM_VENV)"
else
    warn "python venv not found or pynvim missing — creating"
    python3 -m venv "$NVIM_VENV"
    "$NVIM_VENV/bin/pip" install -q pynvim
    ok "pynvim installed in $NVIM_VENV"
fi

# -------------------------------------------------------------------
info "Python tools"
if command -v pylint &>/dev/null; then
    ok "pylint"
else
    warn "pylint not found — installing"
    pip3 install pylint
fi

# -------------------------------------------------------------------
info "Stow symlinks"
cd "$(dirname "$0")/.."
DOTFILES_DIR=$(pwd)
for pkg in kitty nvim starship tmux zsh; do
    if [ -d "$DOTFILES_DIR/$pkg" ]; then
        stow --restow "$pkg" 2>/dev/null && ok "$pkg" || warn "$pkg — stow conflict (run manually)"
    fi
done

# -------------------------------------------------------------------
info "Done! Open a new terminal to apply changes."
