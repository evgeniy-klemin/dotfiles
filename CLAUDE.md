# Dotfiles

## Structure

- `home/` — legacy configs symlinked manually via `install.sh` (zshrc, tmux, vim)
- `kitty/` — kitty terminal config managed via GNU Stow
- `nvim/` — neovim config (Lua-based) managed via GNU Stow
- `install.sh` — legacy install script (apt-get based, Linux only)

## Conventions

- New configs use **GNU Stow** structure: `<app>/.config/<app>/...`
- Install: `cd ~/dotfiles && stow <app>`
- Keep old `home/` configs as-is until explicitly migrated to stow
