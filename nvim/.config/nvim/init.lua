-- Make sure to set `mapleader` before lazy so your mappings are correct
vim.g.mapleader = "."
-- Python3 path: prefer dedicated nvim venv, fallback to system python3
local nvim_python = vim.fn.expand('~/.local/venv/nvim/bin/python')
if vim.fn.executable(nvim_python) == 1 then
    vim.g.python3_host_prog = nvim_python
else
    vim.g.python3_host_prog = vim.fn.exepath('python3')
end

-- plugins
require("config.lazy")
require("user.autocmds")
require("user.options")
require("user.mappings")
