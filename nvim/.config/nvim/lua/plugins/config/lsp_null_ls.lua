local null_ls = require('null-ls')
local M = {}
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

M.opts = {
    sources = {
        null_ls.builtins.formatting.gofumpt,
        null_ls.builtins.formatting.goimports_reviser.with({
            args = {
                "-company-prefixes", "gitlab.diftech.org",
            },
        }),
        null_ls.builtins.formatting.golines.with({
            args = {
                "-m", "120",
            },
        }),
        null_ls.builtins.formatting.black,
        null_ls.builtins.formatting.isort,
        null_ls.builtins.diagnostics.flake8.with({
            prefer_local = "venv/bin",
        }),
        null_ls.builtins.code_actions.gitsigns,
    },
    on_attach = function(client, bufnr)
        if client.supports_method('textDocument/formatting') then
            vim.api.nvim_clear_autocmds({
                group = augroup,
                buffer = bufnr,
            })
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = augroup,
                buffer = bufnr,
                callback = function()
                    vim.lsp.buf.format({ bufnr = bufnr })
                end,
            })
        end
    end,
}

return M
