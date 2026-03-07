# Dotfiles

## Structure

- `kitty/` — kitty terminal config managed via GNU Stow
- `nvim/` — neovim config (Lua-based) managed via GNU Stow
- `tmux/` — tmux config managed via GNU Stow
- `zsh/` — zshrc managed via GNU Stow
- `install.sh` — legacy install script (apt-get based, Linux only)

## Conventions

- New configs use **GNU Stow** structure: `<app>/.config/<app>/...`
- Install: `cd ~/dotfiles && stow <app>`
- Keep old `home/` configs as-is until explicitly migrated to stow
