local M = {}

M.config = function()
    local highlight = {
        "IblCustomIndent",
    }
    local hooks = require("ibl.hooks")
    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "IblCustomIndent", { fg = "#333842" })
    end)
    require('ibl').setup({
        indent = {
            char = '▏',
            highlight = highlight,
        },
    })
end

return M
