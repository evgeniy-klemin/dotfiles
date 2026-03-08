local M = {}

M.config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
        python = { "pylint" },
    }

    lint.linters.pylint.cmd = function()
        local local_pylint = "venv/bin/pylint"
        if vim.fn.executable(local_pylint) == 1 then
            return local_pylint
        end
        return "pylint"
    end

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = vim.api.nvim_create_augroup("NvimLint", { clear = true }),
        callback = function()
            if vim.fn.expand("%:t") ~= "" then
                lint.try_lint()
            end
        end,
    })
end

return M
