# dotfiles

Personal dotfiles for macOS managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Contents

| Package | Files |
|---------|-------|
| `kitty`    | `.config/kitty/kitty.conf`, `current-theme.conf` |
| `nvim`     | `.config/nvim/` (Lua-based neovim config) — [details](nvim/.config/nvim/README.md) |
| `starship` | `.config/starship.toml` |
| `tmux`     | `.tmux.conf` |
| `zsh`      | `.zshrc` (zap + starship, local overrides via `~/.zshrc.local`) |

## Install

Requires [Homebrew](https://brew.sh/).

```bash
git clone https://github.com/evgeniy-klemin/dotfiles.git ~/dotfiles
cd ~/dotfiles
./scripts/setup.sh
```

The setup script checks and installs all dependencies:
- **Brew**: stow, starship, lsd, fzf, ranger, neovim, node, ripgrep, imagemagick, luarocks
- **Zap**: zsh plugin manager (autosuggestions, syntax-highlighting, completions)
- **npm**: tree-sitter-cli, neovim
- **Luarocks**: magick (image.nvim)
- **Python**: pynvim (neovim provider), pylint (linter)
- **Stow**: symlinks all packages to `$HOME`

## Adding new packages

```bash
mkdir -p newpkg/.config/newpkg
# add config files...
stow newpkg
```
