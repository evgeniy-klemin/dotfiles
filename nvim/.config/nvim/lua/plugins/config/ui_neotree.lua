local M = {}

M.config = function()
    vim.fn.sign_define("DiagnosticSignError",
        { text = " ", texthl = "DiagnosticSignError" })
    vim.fn.sign_define("DiagnosticSignWarn",
        { text = " ", texthl = "DiagnosticSignWarn" })
    vim.fn.sign_define("DiagnosticSignInfo",
        { text = " ", texthl = "DiagnosticSignInfo" })
    vim.fn.sign_define("DiagnosticSignHint",
        { text = "󰌵", texthl = "DiagnosticSignHint" })
    local cfg = {
        popup_border_style = 'single',
        close_if_last_window = true,
        enable_git_status = true,
        enable_diagnostics = true,
        sync_root_with_cwd = true,
        respect_buf_cwd = true,
        window = {
            mappings = {
                ['<space>'] = false,
                P = { "toggle_preview", config = { use_float = false, use_image_nvim = true } },
                x = 'close_node',
                o = 'open',
                t = 'open',
                z = false,
                h = "parent_or_close",
                l = "child_or_open",
                F = "find_in_dir",
                O = "system_open",
                Y = "copy_selector",
            },
            fuzzy_finder_mappings = {
                ["<C-j>"] = "move_cursor_down",
                ["<C-k>"] = "move_cursor_up",
            },
        },
        filesystem = {
            follow_current_file = {
                enabled = true,
                leave_dirs_open = false,
            },
            filtered_items = {
                hide_by_name = {
                    "venv"
                },
                always_show = { -- remains visible even if other settings would normally hide it
                    ".gitlab-ci.yml",
                },
            },
        },
        buffers = {
            follow_current_file = {
                enabled = true,
                leave_dirs_open = false,
            },
        },
        use_libuv_file_watcher = true,
        event_handlers = {
            {
                event = "neo_tree_buffer_enter",
                handler = function(_) vim.opt_local.signcolumn = "auto" end,
            },
        },
        sources = { "filesystem", "buffers", "git_status" },
        source_selector = {
            winbar = true,
            content_layout = "center",
            sources = {
                { source = "filesystem", display_name = " File" },
                { source = "buffers", display_name = "󰈙 Bufs" },
                { source = "git_status", display_name = "󰊢 Git" },
                { source = "diagnostics", display_name = "󰱑 Diag" },
            },
        },
        commands = {
            system_open = function(state)
                vim.ui.open.system_open(state.tree:get_node():get_id())
            end,
            parent_or_close = function(state)
                local node = state.tree:get_node()
                if (node.type == "directory" or node:has_children()) and node:is_expanded() then
                    state.commands.toggle_node(state)
                else
                    require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
                end
            end,
            child_or_open = function(state)
                local node = state.tree:get_node()
                if node.type == "directory" or node:has_children() then
                    if not node:is_expanded() then -- if unexpanded, expand
                        state.commands.toggle_node(state)
                    else                           -- if expanded and has children, seleect the next child
                        require("neo-tree.ui.renderer").focus_node(state, node:get_child_ids()[1])
                    end
                else -- if not a directory just open it
                    state.commands.open(state)
                end
            end,
            copy_selector = function(state)
                local node = state.tree:get_node()
                local filepath = node:get_id()
                local filename = node.name
                local modify = vim.fn.fnamemodify

                local vals = {
                    ["BASENAME"] = modify(filename, ":r"),
                    ["EXTENSION"] = modify(filename, ":e"),
                    ["FILENAME"] = filename,
                    ["PATH (CWD)"] = modify(filepath, ":."),
                    ["PATH (HOME)"] = modify(filepath, ":~"),
                    ["PATH"] = filepath,
                    ["URI"] = vim.uri_from_fname(filepath),
                }

                local options = vim.tbl_filter(function(val) return vals[val] ~= "" end, vim.tbl_keys(vals))
                if vim.tbl_isempty(options) then
                    vim.notify("No values to copy", vim.log.levels.WARN)
                    return
                end
                table.sort(options)
                vim.ui.select(options, {
                    prompt = "Choose to copy to clipboard:",
                    format_item = function(item) return ("%s: %s"):format(item, vals[item]) end,
                }, function(choice)
                    local result = vals[choice]
                    if result then
                        vim.notify(("Copied: `%s`"):format(result))
                        vim.fn.setreg("+", result)
                    end
                end)
            end,
            find_in_dir = function(state)
                local node = state.tree:get_node()
                local path = node:get_id()
                local cwd = node.type == "directory" and path or vim.fn.fnamemodify(path, ":h")
                vim.cmd("FzfLua live_grep_glob cwd=" .. cwd)
            end,
        }
    }
    require("neo-tree").setup(cfg)

    vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
            require("user.utils").toggle_neotree("source=filesystem")
        end,
    })
end

return M
