local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local group = augroup("on_bufenter", { clear = true })
autocmd("BufEnter", {
    callback = function()
        vim.opt_local.formatoptions:remove({ "r", "o" })
    end,
    desc = "After pressing <Enter> in insert mode, and on 'o' or 'O', disable inserting comment leader.",
    group = group,
    pattern = "*",
})

-- auto toggle tagbar on file enter
group = augroup("open_tagbar", { clear = true })
autocmd("BufWinEnter", {
    callback = function()
        vim.cmd('TagbarOpen')
    end,
    desc = "Open Tagbar on file enter.",
    group = group,
    pattern = { "*.go", "*.py" },
})
autocmd("BufWinLeave", {
    callback = function()
        vim.cmd('TagbarClose')
    end,
    desc = "Close Tagbar on file exit.",
    group = group,
    pattern = { "*.go", "*.py" },
})

group = augroup("clean_onsave", { clear = true })
autocmd("BufWritePre", {
    callback = function()
        vim.cmd [[StripWhitespace]]
    end,
    desc = "Remove trailing whitespace and newlines on save.",
    group = group,
    pattern = "*",
})

group = augroup("highlight_yank", { clear = true })
autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
    end,
    desc = "Highlight selection on yank.",
    group = group,
    pattern = "*",
})

group = augroup("update_file", { clear = true })
autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
    callback = function()
        local regex = vim.regex([[\(c\|r.?\|!\|t\)]])
        local mode = vim.api.nvim_get_mode()["mode"]
        if (not regex:match_str(mode)) and vim.fn.getcmdwintype() == "" then
            vim.cmd("checktime")
        end
    end,
    desc = "If the file is changed outside of neovim, reload it automatically.",
    group = group,
    pattern = "*",
})
autocmd("FileChangedShellPost", {
    callback = function()
        vim.notify("File changed on disk. Buffer reloaded!", vim.log.levels.WARN)
    end,
    desc = "If the file is changed outside of neovim, reload it automatically.",
    group = group,
    pattern = "*",
})

group = augroup("restore_cur_pos", { clear = true })
autocmd("BufReadPost", {
    command = [[if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g`\"zz" | endif]],
    desc = "Restore cursor position to last known position on read.",
    group = group,
    pattern = "*",
})
