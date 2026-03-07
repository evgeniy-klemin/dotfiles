# Dotfiles

## Structure

- `kitty/` — kitty terminal config managed via GNU Stow
- `nvim/` — neovim config (Lua-based) managed via GNU Stow
- `tmux/` — tmux config managed via GNU Stow
- `starship/` — starship prompt config managed via GNU Stow
- `zsh/` — zshrc (zap + starship) managed via GNU Stow
## Conventions

- All configs use **GNU Stow** structure: `<app>/.config/<app>/...`
- Install: `cd ~/dotfiles && stow <app>`
- Starship config is written via Python to preserve Nerd Font unicode icons
