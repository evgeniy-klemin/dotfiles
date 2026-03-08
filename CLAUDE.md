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

## Neovim key plugins

- **LSP**: mason.nvim + native `vim.lsp.config`/`vim.lsp.enable` (nvim 0.11+)
- **Completion**: nvim-cmp (manual trigger via `<C-Space>`)
- **AI inline suggestions**: windsurf.vim (Codeium) — `<Tab>` accept, `<M-]>`/`<M-[>` cycle
- **Formatting/linting**: none-ls (null-ls) with prettier, stylua, isort, black, pylint
- **Fuzzy finder**: FzfLua (requires ripgrep for live_grep)
- **Treesitter**: nvim-treesitter v2 (`require('nvim-treesitter')`)
- **Folds**: nvim-ufo

## Running nvim checkhealth headless

```bash
HOME=/Users/eklemin /usr/local/bin/nvim --headless -c 'lua vim.defer_fn(function() vim.cmd("checkhealth") vim.defer_fn(function() local buf = vim.api.nvim_get_current_buf() local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false) local f = io.open(vim.fn.expand("~/nvim-ch.txt"), "w") for _, l in ipairs(lines) do f:write(l .. "\n") end f:close() os.exit(0) end, 10000) end, 3000)' 2>/dev/null &
NVIM_PID=$!
sleep 20
kill $NVIM_PID 2>/dev/null
command cat ~/nvim-ch.txt | head -600
```

- Use `vim.defer_fn` (3s init + 10s for checks to finish)
- Write to `~/` not `/tmp/` (sandbox redirects /tmp)
- Use `os.exit(0)` not `qa!` (StripWhitespace autocmd errors on non-modifiable buffer)
- Use `command cat` to bypass lsd alias
