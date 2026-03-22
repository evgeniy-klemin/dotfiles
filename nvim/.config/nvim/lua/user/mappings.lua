local utils = require("user.utils")

local map = vim.keymap.set
--local e_opts = { expr = true }
local s_opts = function(desc)
    return { silent = true, desc = desc }
end
local se_opts = function(desc)
    return { silent = true, expr = true, desc = desc }
end


-- remap Ex mode to exit
map("n", "Q", "<cmd>q<CR>", s_opts("Exit"))

-- Minuet AI: Tab accepts suggestion if visible, otherwise inserts normal Tab
map("i", "<Tab>", function()
    local action = require('minuet.virtualtext').action
    if action.is_visible() then
        action.accept()
        return ""
    else
        return "<Tab>"
    end
end, { noremap = true, expr = true, silent = true, desc = "Accept AI suggestion or insert Tab" })

-- open terminal in popup
map("n", "<Leader><Leader>t", function()
    vim.cmd [[FloatermToggle]]
end, s_opts("Open terminal in popup"))
map("t", "<Leader><Leader>t", "<C-\\><C-n><cmd>FloatermToggle<CR>", s_opts("Close terminal in popup"))
map("t", "<Esc>", "<C-\\><C-n>", s_opts("Go to normal mode in terminal"))

-- Toggle fold (single level)
map("n", "<Space><Space>", "foldlevel('.') ? 'za' : '<Space>'", se_opts("Toggle fold"))

-- move line / block
map("n", "<A-j>", ":m .+1<CR>==", s_opts("Move line down"))
map("n", "<A-k>", ":m .-2<CR>==", s_opts("Move line up"))
map("v", "<A-j>", ":m '>+1<CR>gv-gv", s_opts("Move block down"))
map("v", "<A-k>", ":m '<-2<CR>gv-gv", s_opts("Move block up"))

-- Text helpers
-- add a new line before and after the cursor
-- map("n", "oo", "o<Esc>k", s_opts("Add new line below"))
-- map("n", "OO", "O<Esc>j", s_opts("Add new line above"))

-- fzf mapping
map("n", "<Leader>ff", "<cmd>FzfLua files<CR>", s_opts("Fuzzy find files"))
map("n", "<Leader>fgf", "<cmd>FzfLua git_files<CR>", s_opts("Fuzzy find git files"))
map("n", "<Leader>fgb", "<cmd>FzfLua git_branches<CR>", s_opts("Fuzzy find git branches"))
map("n", "<Leader>fl", "<cmd>FzfLua live_grep_glob<CR>", s_opts("Fuzzy find in files"))
map("n", "<Leader>fr", "<cmd>FzfLua resume<CR>", s_opts("Fuzzy find resume"))

-- copy word under cursor using buffer 1
map("n", "yw", 'viw"1y', s_opts("Copy word under cursor"))
map("n", "pw", 'viw"1p', s_opts("Paste word under cursor"))

-- Buffer management
map("n", "<S-h>", "<cmd>BufferLineCyclePrev<CR>", s_opts("Previous buffer"))
map("n", "<S-l>", "<cmd>BufferLineCycleNext<CR>", s_opts("Next buffer"))
map("n", "<Leader>w", function()
    require("bufdelete").bufdelete(0, true)
    -- require("bufdelete").bufwipeout(0, true) -- remove from Ctrl-o navigation
end, s_opts("Close buffer"))
map("n", "<Leader>W", "<cmd>BufferLineCloseOthers<CR>", s_opts("Close other buffers"))

-- Neotree
map("n", "<S-f>", function()
    utils.toggle_neotree("source=filesystem toggle=true")
end, s_opts("Toggle Neotree"))
map("n", "f", "<cmd>Neotree reveal_force_cwd<CR>", s_opts("Reveal current file in Neotree"))
map("n", "<Leader>gb", function()
    local function git_cmd(cmd)
        local out = vim.fn.systemlist(cmd)
        if vim.v.shell_error ~= 0 then return nil end
        return out[1]
    end
    -- Detect default branch on remote (origin)
    local base_ref
    local symbolic = git_cmd("git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null")
    if symbolic then
        base_ref = symbolic:match("refs/remotes/(.+)")
    end
    if not base_ref then
        if git_cmd("git rev-parse --verify origin/main 2>/dev/null") then
            base_ref = "origin/main"
        elseif git_cmd("git rev-parse --verify origin/master 2>/dev/null") then
            base_ref = "origin/master"
        end
    end
    if not base_ref then
        vim.notify("Cannot determine base branch", vim.log.levels.WARN)
        return
    end
    vim.g._neotree_git_base = base_ref
    -- Switch to filesystem first to force neo-tree to re-navigate git_status
    vim.cmd("Neotree source=filesystem")
    vim.schedule(function()
        vim.cmd("Neotree source=git_status git_base=" .. base_ref)
    end)
    -- Show gitsigns diff against base branch too
    local gs = require("gitsigns")
    gs.change_base(base_ref, true)
    gs.toggle_current_line_blame(false)
end, s_opts("Neotree: branch changes vs base"))
map("n", "<Leader>gs", function()
    vim.g._neotree_git_base = nil
    vim.cmd("Neotree source=filesystem")
    vim.schedule(function()
        vim.cmd("Neotree source=git_status git_base=HEAD")
    end)
    -- Reset gitsigns to default (HEAD)
    local gs = require("gitsigns")
    gs.reset_base(true)
    gs.toggle_current_line_blame(true)
end, s_opts("Neotree: uncommitted changes"))

-- Toggle wrap
map("n", "<Leader>tw", "<cmd>set wrap!<CR>", s_opts("Toggle line wrap"))

-- Format
map("n", "<Leader>fm", function()
    require("conform").format({ async = true, lsp_format = "fallback" })
end, s_opts("Format file"))

-- Fold
map('n', 'zR', require('ufo').openAllFolds, s_opts("Open all folds"))
map('n', 'zM', require('ufo').closeAllFolds, s_opts("Close all folds"))
map('n', 'zfm', '<cmd>let &l:foldmethod="marker"<CR>', s_opts("Set foldmethod to marker"))

-- Resizing splits
-- these keymaps will also accept a range,
-- for example `10<S-A-h>` will `resize_left` by `(10 * config.default_amount)`
vim.keymap.set('n', '<S-A-h>', require('smart-splits').resize_left)
vim.keymap.set('n', '<S-A-j>', require('smart-splits').resize_down)
vim.keymap.set('n', '<S-A-k>', require('smart-splits').resize_up)
vim.keymap.set('n', '<S-A-l>', require('smart-splits').resize_right)
-- moving between splits
vim.keymap.set('n', '<C-h>', require('smart-splits').move_cursor_left)
vim.keymap.set('n', '<C-j>', require('smart-splits').move_cursor_down)
vim.keymap.set('n', '<C-k>', require('smart-splits').move_cursor_up)
vim.keymap.set('n', '<C-l>', require('smart-splits').move_cursor_right)
-- swapping buffers between windows
vim.keymap.set('n', '<leader><leader>h', require('smart-splits').swap_buf_left)
vim.keymap.set('n', '<leader><leader>j', require('smart-splits').swap_buf_down)
vim.keymap.set('n', '<leader><leader>k', require('smart-splits').swap_buf_up)
vim.keymap.set('n', '<leader><leader>l', require('smart-splits').swap_buf_right)

-- Claude Code helpers
-- relative path
map('n', '<leader>yf', function()
  vim.fn.setreg('+', vim.fn.expand('%:.') .. ':' .. vim.fn.line('.'))
  print('Copied: ' .. vim.fn.getreg('+'))
end, { desc = 'Yank file:line (relative)' })

map('v', '<leader>yf', function()
  local start_line = vim.fn.line("'<")
  local end_line = vim.fn.line("'>")
  vim.fn.setreg('+', vim.fn.expand('%:.') .. ':' .. start_line .. '-' .. end_line)
  print('Copied: ' .. vim.fn.getreg('+'))
end, { desc = 'Yank file:lines (relative)' })

-- absolute path
map('n', '<leader>yF', function()
  vim.fn.setreg('+', vim.fn.expand('%:p') .. ':' .. vim.fn.line('.'))
  print('Copied (abs): ' .. vim.fn.getreg('+'))
end, { desc = 'Yank file:line (absolute)' })

map('v', '<leader>yF', function()
  local start_line = vim.fn.line("'<")
  local end_line = vim.fn.line("'>")
  vim.fn.setreg('+', vim.fn.expand('%:p') .. ':' .. start_line .. '-' .. end_line)
  print('Copied (abs): ' .. vim.fn.getreg('+'))
end, { desc = 'Yank file:lines (absolute)' })
