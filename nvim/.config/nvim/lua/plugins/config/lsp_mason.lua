local M = {}

M.config = function()
    require('mason').setup()
    require('lspconfig') -- register lspconfig's lsp/ configs for vim.lsp.config

    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    vim.lsp.config('gopls', {
        capabilities = capabilities,
        settings = {
            gopls = {
                experimentalPostfixCompletions = true,
                staticcheck = false,
                completeUnimported = true,
                usePlaceholders = true,
            },
        },
        init_options = {
            usePlaceholders = true,
            completeUnimported = true,
        },
    })
    vim.lsp.enable('gopls')

    vim.lsp.config('golangci_lint_ls', {
        capabilities = capabilities,
    })
    vim.lsp.enable('golangci_lint_ls')

    vim.lsp.config('pyright', {
        capabilities = capabilities,
        settings = {
            pyright = { autoImportCompletion = true },
            python = {
                pythonPath = 'venv/bin/python',
                venvPath = '.',
                analysis = {
                    autoSearchPaths = true,
                    diagnosticMode = 'openFilesOnly',
                    useLibraryCodeForTypes = true,
                    typeCheckingMode = 'off',
                },
            },
        },
    })
    vim.lsp.enable('pyright')

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
            'golangci_lint_ls',
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
            "prettier",
            "stylua",
            "isort",
            "black",
            "pylint",
            "gofumpt",
            "goimports-reviser",
            "golines",
        },
    }
end

return M
