local M = {}

M.config = function()
    vim.cmd [[TSUpdate]]
    require('nvim-treesitter.configs').setup {
        ensure_installed = {
            "go",
            "python",
            "lua",
            "vim",
            "vimdoc",
            "query",
            "bash",
            "csv",
            "diff",
            "dockerfile",
            "gitignore",
            "gomod",
            "html",
            "javascript",
            "json",
            "make",
            "markdown",
            "regex",
            "toml",
            "typescript",
            "xml",
            "yaml",
        },
    }
end

return M
