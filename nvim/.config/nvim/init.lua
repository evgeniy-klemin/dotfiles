-- Make sure to set `mapleader` before lazy so your mappings are correct
vim.g.mapleader = "."
-- Python3 path
vim.go.python3_host_prog = vim.fn.expand('$HOME') .. "./.local/venv/nvim/bin/python"

-- plugins
require("config.lazy")
require("user.autocmds")
require("user.options")
require("user.mappings")
