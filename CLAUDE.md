# Dotfiles

## Structure

- `kitty/` — kitty terminal config managed via GNU Stow
- `nvim/` — neovim config (Lua-based) managed via GNU Stow
- `tmux/` — tmux config managed via GNU Stow
- `starship/` — starship prompt config managed via GNU Stow
- `zsh/` — zshrc (zap + starship) managed via GNU Stow
  - `zsh/.config/zsh/completions/` — custom completion functions (in `fpath`), e.g. `_claude` for the Claude Code CLI: parses `claude … --help` (cached in `~/.cache/zsh/claude-help`, refreshed when the binary changes) plus dynamic values (sessions, agents, MCP servers, plugins)
- `claude-kitty/` — vendored [kitty-extensions](https://github.com/jLAM-ERR/kitty-extensions) tmux-shim: fake `tmux` (`~/.claude/kitty-tmux-shim/bin/tmux`) + launcher `~/.local/bin/claude-kitty` (`claude --teammate-mode tmux` with the shim on `PATH` for that process only) so agent-team teammates open as kitty splits. **Stow with `--no-folding`** (shim writes `shim.log`/`state.json` into `~/.claude/kitty-tmux-shim/`). Upstream SHA + update steps in `claude-kitty/README.md`. Local addition `claude-kitty-rc-proxy`: runs a nono-sandboxed lead without giving it kitty's socket (full kitty control); it relays only the shim's commands and wraps every teammate in the lead's nono prefix
- `scripts/` — helper scripts (not stowed)

## Conventions

- All configs use **GNU Stow** structure: `<app>/.config/<app>/...`
- Install: `cd ~/dotfiles && stow <app>`
- Starship config is written via Python to preserve Nerd Font unicode icons
- Local overrides (API keys, etc.) go in `~/.zshrc.local` (not tracked)

## Neovim key plugins

- **LSP**: mason.nvim + native `vim.lsp.config`/`vim.lsp.enable` (nvim 0.11+)
- **Completion**: nvim-cmp (manual trigger via `<C-Space>`) + cmp-cmdline (`:` and `/` completion)
- **AI inline suggestions**: minuet-ai.nvim (local Ollama, JetBrains Mellum-4b) — `<Tab>` accept, `<A-a>` accept line, `<A-]>`/`<A-[>` cycle, `<A-e>` dismiss
- **Formatting**: conform.nvim with prettier, stylua, isort, black, gofumpt, goimports-reviser, golines
- **Linting**: nvim-lint with pylint
- **Fuzzy finder**: FzfLua (requires fzf + ripgrep)
- **Treesitter**: nvim-treesitter v2 (`require('nvim-treesitter')`)
- **Folds**: nvim-ufo

## Local AI code suggestions (Ollama)

AI inline suggestions require a locally running Ollama instance with the JetBrains Mellum model:

```bash
brew install ollama
brew services start ollama
ollama pull JetBrains/Mellum-4b-sft-all
```

Ollama launchd plist (`/opt/homebrew/opt/ollama/homebrew.mxcl.ollama.plist`) is configured with:
- `OLLAMA_KEEP_ALIVE=-1` — keeps model permanently loaded in GPU memory
- `OLLAMA_FLASH_ATTENTION=1` — faster attention computation
- `OLLAMA_KV_CACHE_TYPE=q8_0` — quantized KV cache to reduce memory usage

Performance tuning (minuet config): `context_window=600`, `max_tokens=40` — optimized for ~1 sec response on M1 Pro (200 GB/s memory bandwidth). Prompt processing (prefill) is the main latency bottleneck.

## Running nvim checkhealth headless

```bash
./scripts/nvim-checkhealth.sh
```

- Use `vim.defer_fn` (3s init + 10s for checks to finish)
- Write to `~/` not `/tmp/` (sandbox redirects /tmp)
- Use `os.exit(0)` not `qa!` (StripWhitespace autocmd errors on non-modifiable buffer)
- Use `command cat` to bypass lsd alias
