# Dotfiles

## Structure

- `kitty/` — kitty terminal config managed via GNU Stow
- `nvim/` — neovim config (Lua-based) managed via GNU Stow
- `tmux/` — tmux config managed via GNU Stow
- `starship/` — starship prompt config managed via GNU Stow
- `zsh/` — zshrc (zap + starship) managed via GNU Stow
- `scripts/` — helper scripts (not stowed)

## Conventions

- All configs use **GNU Stow** structure: `<app>/.config/<app>/...`
- Install: `cd ~/dotfiles && stow <app>`
- Starship config is written via Python to preserve Nerd Font unicode icons
- Local overrides (API keys, etc.) go in `~/.zshrc.local` (not tracked)

## Neovim key plugins

- **LSP**: mason.nvim + native `vim.lsp.config`/`vim.lsp.enable` (nvim 0.11+)
- **Completion**: nvim-cmp (manual trigger via `<C-Space>`) + cmp-cmdline (`:` and `/` completion)
- **AI inline suggestions**: windsurf.vim (Codeium) — `<Tab>` accept, `<M-]>`/`<M-[>` cycle
- **Formatting/linting**: none-ls (null-ls) with prettier, stylua, isort, black, pylint
- **Fuzzy finder**: FzfLua (requires fzf + ripgrep)
- **Treesitter**: nvim-treesitter v2 (`require('nvim-treesitter')`)
- **Folds**: nvim-ufo

## Running nvim checkhealth headless

```bash
./scripts/nvim-checkhealth.sh
```

- Use `vim.defer_fn` (3s init + 10s for checks to finish)
- Write to `~/` not `/tmp/` (sandbox redirects /tmp)
- Use `os.exit(0)` not `qa!` (StripWhitespace autocmd errors on non-modifiable buffer)
- Use `command cat` to bypass lsd alias
