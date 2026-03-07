local M = {}

--- Launch external program
--- @param prog string program to run
--- @vararg string args for program
function M.launch_ext_prog(prog, ...)
    vim.fn.system(prog .. " " .. table.concat({ ... }, " "))
end

function M.toggle_neotree(cmd)
    local cur_win_id = vim.api.nvim_get_current_win()
    local cur_win_layout = vim.fn.winsaveview()
    vim.cmd("silent! Neotree " .. cmd)
    vim.wo.signcolumn = "no"
    if vim.api.nvim_win_is_valid(cur_win_id) then
        vim.api.nvim_set_current_win(cur_win_id)
        vim.fn.winrestview(cur_win_layout)
    end
end

return M
