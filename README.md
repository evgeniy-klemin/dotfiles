# dotfiles

Personal dotfiles for macOS managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Contents

| Package | Files |
|---------|-------|
| `kitty`    | `.config/kitty/kitty.conf` |
| `nvim`     | `.config/nvim/` (Lua-based neovim config) — [details](nvim/.config/nvim/README.md) |
| `starship` | `.config/starship.toml` |
| `tmux`     | `.tmux.conf` |
| `zsh`      | `.zshrc` (zap + starship, local overrides via `~/.zshrc.local`) |

## Requirements

- [Homebrew](https://brew.sh/)
- GNU Stow: `brew install stow`
- [Zap](https://github.com/zap-zsh/zap) plugin manager

```bash
brew install starship lsd fzf ranger neovim
```

| Tool | Purpose |
|------|---------|
| [starship](https://starship.rs/) | Cross-shell prompt |
| [lsd](https://github.com/lsd-rs/lsd) | Modern `ls` replacement (used in `ls`/`ll`/`lt` aliases); requires a [Nerd Font](https://www.nerdfonts.com/) |
| [fzf](https://github.com/junegunn/fzf) | Fuzzy finder (`~/.fzf.zsh` keybindings) |
| [ranger](https://ranger.github.io/) | Terminal file manager (wrapped in `rng` function) |
| [neovim](https://neovim.io/) | Editor (`vim`/`vimdiff` aliases point to `nvim`) |

**Optional** (completions are loaded automatically if installed):

| Tool | Purpose |
|------|---------|
| `kubectl` | Kubernetes CLI |
| `docker` | Docker CLI |
| `temporal` | Temporal workflow CLI |
| `tctl` | Temporal server CLI |

## Install

```bash
git clone https://github.com/evgeniy-klemin/dotfiles.git ~/dotfiles
cd ~/dotfiles
stow kitty nvim starship tmux zsh
```

## Adding new packages

Create a directory with the same structure as `$HOME`, then stow it:

```bash
mkdir -p newpkg/.config/newpkg
# add config files...
stow newpkg
```
