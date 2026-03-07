local M = {}

M.config = function()
    require('mason').setup()

    -- config for lspconfig
    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    require("lspconfig").gopls.setup{
        capabilities = capabilities,
        cmd = {"gopls"},
        filetypes = {"go", "gomod", "gowork", "gotmpl"},
        root_dir = require("lspconfig/util").root_pattern("go.work", "go.mod", ".git"),
        settings = {
            gopls = {
                experimentalPostfixCompletions = true,
                staticcheck = true,
                completeUnimported = true,
                usePlaceholders = true,
                analyses = {
                    unusedparams = true,
                    shadow = true,
                },
            },
        },
        init_options = {
            usePlaceholders = true,
            completeUnimported = true,
        },
    }

    require("lspconfig").pyright.setup{
        capabilities = capabilities,
        settings = {
            pyright = {
                autoImportCompletion = true,
            },
            python = {
                pythonPath = 'venv/bin/python',
                venvPath = '.',
                analysis = {
                    autoSearchPaths = true,
                    diagnosticMode = 'openFilesOnly',
                    useLibraryCodeForTypes = true,
                    typeCheckingMode = 'off'
                }
            }
        },
    }

    local opts = { noremap = true, silent = true }
    vim.api.nvim_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
    vim.api.nvim_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
    vim.api.nvim_set_keymap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
    vim.api.nvim_set_keymap("n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
end

M.lspconfig_opts = function()
    return {
        ensure_installed = {
            'gopls',
            'lua_ls',
            -- python
            'pylsp',
            'pyright',
        },
    }
end

M.tool_installer_opts = function()
    return {
        ensure_installed = {
            "prettier", -- prettier formatter
            "stylua", -- lua formatter
            "isort", -- python formatter
            "black", -- python formatter
            "flake8", -- js linter
        },
    }
end

return M
