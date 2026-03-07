# dotfiles

Personal dotfiles for macOS managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Contents

| Package | Files |
|---------|-------|
| `kitty` | `.config/kitty/kitty.conf` |
| `nvim`  | `.config/nvim/` (Lua-based neovim config) — [details](nvim/.config/nvim/README.md) |
| `tmux`  | `.tmux.conf` |
| `zsh`   | `.zshrc` (oh-my-zsh + p10k, local overrides via `~/.zshrc.local`) |

## Requirements

- [Homebrew](https://brew.sh/)
- GNU Stow: `brew install stow`
- [oh-my-zsh](https://ohmyz.sh/)
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k) theme
- `brew install lsd fzf ranger`

## Install

```bash
git clone https://github.com/evgeniy-klemin/dotfiles.git ~/dotfiles
cd ~/dotfiles
stow kitty nvim tmux zsh
```

## Adding new packages

Create a directory with the same structure as `$HOME`, then stow it:

```bash
mkdir -p newpkg/.config/newpkg
# add config files...
stow newpkg
```
