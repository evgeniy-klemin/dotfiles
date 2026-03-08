local M = {}

M.opts = {
    formatters_by_ft = {
        go = { "goimports_reviser", "gofumpt", "golines" },
        python = { "isort", "black" },
        lua = { "stylua" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        markdown = { "prettier" },
    },
    format_on_save = {
        timeout_ms = 3000,
        lsp_format = "fallback",
    },
    formatters = {
        goimports_reviser = {
            prepend_args = { "-company-prefixes", "gitlab.diftech.org" },
        },
        golines = {
            prepend_args = { "-m", "120" },
        },
    },
}

return M
