-- No wrap
vim.o.wrap = false

-- File encoding
vim.o.fileencoding = "utf-8"

-- Enable dark background colorschemes
vim.o.background = "dark"
-- Enable 24bit colors in terminal
vim.o.termguicolors = true

-- Auto-indent new lines
vim.o.autoindent = true
-- Enable smart-indent
vim.o.smartindent = true

-- Use spaces instead of tabs
vim.o.expandtab = true
-- Number of auto-indent spaces
vim.o.shiftwidth = 4
-- Number of spaces per Tab
vim.o.softtabstop = 4
-- Number of columns per tab
vim.o.tabstop = 4

-- No wrap
vim.o.wrap = false

-- Always case-insensitive
vim.o.ignorecase = true
-- Enable smart-case search
vim.o.smartcase = true
-- Searches for strings incrementally
vim.o.incsearch = true

-- Show line numbers
vim.o.number = true
-- Enable relative line numbers
vim.o.relativenumber = true

-- Always have at least 5 lines before the window's bottom
vim.o.scrolloff = 5

-- Timeout for command
vim.o.timeout = true
vim.o.timeoutlen = 300

-- No redraw during macro, regex execution
vim.o.lazyredraw = true

-- Enable mouse for normal and visual modes
vim.o.mouse = "nv"

-- Copy and past visual selection using system buffer
vim.opt.clipboard:append("unnamedplus")

-- Display chars, call :set list
vim.opt.listchars:append({ tab = " ", lead = "·", trail = "·", eol = "﬋" })

-- Disable builtin vim plugins
local disabled_built_ins = {
    "netrw",
    "netrwPlugin",
    "netrwSettings",
    "netrwFileHandlers",
    "gzip",
    "zip",
    "zipPlugin",
    "tar",
    "tarPlugin",
    "getscript",
    "getscriptPlugin",
    "vimball",
    "vimballPlugin",
    "2html_plugin",
    "logipat",
    "rrhelper",
    "matchit",
}

for _, plugin in pairs(disabled_built_ins) do
    vim.g["loaded_" .. plugin] = 1
end

-- Disable perl provider
vim.g.loaded_perl_provider = 0

-- Disable ruby provider
vim.g.loaded_ruby_provider = 0

-- Fold
vim.o.foldcolumn = '1'
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:⏵]]
vim.o.colorcolumn = '120'
vim.o.textwidth = 120
vim.cmd.highlight("FoldColumn guibg=#333842 guifg=grey")
