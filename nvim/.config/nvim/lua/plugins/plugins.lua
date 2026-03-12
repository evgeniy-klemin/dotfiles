return {
    ---------------------------------------------------------------------------
    -- Themes {{{
    ---------------------------------------------------------------------------
    { 'ryanoasis/vim-devicons' },
    {
        'tanvirtin/monokai.nvim',
        config = function() require('monokai').setup() end
    },
    -- }}}
    ---------------------------------------------------------------------------


    ---------------------------------------------------------------------------
    -- UI {{{
    ---------------------------------------------------------------------------
    {
        'rcarriga/nvim-notify',
        dependencies = { 'tanvirtin/monokai.nvim' },
        config = require('plugins.config.ui_notify').config,
    },
    {
        -- start screen
        'goolord/alpha-nvim',
        dependencies = {
            'nvim-tree/nvim-web-devicons',
            'tanvirtin/monokai.nvim',
        },
        config = require('plugins.config.ui_alpha').config,
    },
    {
        'lukas-reineke/indent-blankline.nvim',
        dependencies = { 'tanvirtin/monokai.nvim' },
        config = require('plugins.config.ui_blankline').config,
    },
    { 'lukas-reineke/virt-column.nvim', dependencies = { 'tanvirtin/monokai.nvim' } },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = {
            'nvim-tree/nvim-web-devicons',
            'tanvirtin/monokai.nvim',
        },
        config = function() require('lualine').setup() end
    },
    { 'ntpeters/vim-better-whitespace' },
    { 'famiu/bufdelete.nvim' },
    {
        'akinsho/bufferline.nvim',
        version = '*',
        dependencies = {
            'nvim-tree/nvim-web-devicons',
            'tanvirtin/monokai.nvim',
        },
        config = require('plugins.config.ui_bufferline').config,
    },
    {
        's1n7ax/nvim-window-picker',
        name = 'window-picker',
        event = 'VeryLazy',
        version = '2.*',
        config = function() require('window-picker').setup() end,
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "main",
        init = function() vim.g.neo_tree_remove_legacy_commands = true end,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
            "3rd/image.nvim",
            's1n7ax/nvim-window-picker',
            'tanvirtin/monokai.nvim',
        },
        config = require("plugins.config.ui_neotree").config,
    },
    {
        'luukvbaal/statuscol.nvim',
        dependencies = { 'tanvirtin/monokai.nvim', 'lewis6991/gitsigns.nvim' },
        config = require('plugins.config.ui_statuscol').config,
    },
    {
        "kevinhwang91/nvim-ufo",
        dependencies = { "kevinhwang91/promise-async" },
        config = require("plugins.config.ui_ufo").config,
    },
    -- }}}
    ---------------------------------------------------------------------------


    ---------------------------------------------------------------------------
    -- Features {{{
    ---------------------------------------------------------------------------
    {
        'numToStr/Comment.nvim',
        opts = {
            -- add any options here
        },
        lazy = false,
    },
    { 'embear/vim-localvimrc' },
    { 'tpope/vim-fugitive',     version = '*' },
    { 'mg979/vim-visual-multi', branch = 'master' },
    {
        -- send code to interactive interpretator
        'jpalardy/vim-slime',
        config = require('plugins.config.feat_slime').config,
    },
    { 'voldikss/vim-floaterm' }, -- open terminal in popup window
    {
        "mrjones2014/smart-splits.nvim",
        lazy = true,
        opts = { ignored_filetypes = { "nofile", "quickfix", "qf", "prompt" }, ignored_buftypes = { "nofile" } },
    },
    -- }}}
    ---------------------------------------------------------------------------


    ---------------------------------------------------------------------------
    -- Syntax support {{{
    ---------------------------------------------------------------------------
    {
        'nvim-treesitter/nvim-treesitter',
        config = require('plugins.config.syntax_treesitter').config,
    },
    -- }}}
    ---------------------------------------------------------------------------


    ---------------------------------------------------------------------------
    -- LSP {{{
    ---------------------------------------------------------------------------
    {
        'williamboman/mason.nvim',
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'onsails/lspkind.nvim',
            'neovim/nvim-lspconfig',
        },
        config = require('plugins.config.lsp_mason').config,
    },
    {
        'williamboman/mason-lspconfig.nvim',
        dependencies = { 'williamboman/mason.nvim' },
        opts = require('plugins.config.lsp_mason').lspconfig_opts,
    },
    {
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        dependencies = { 'williamboman/mason.nvim' },
        opts = require('plugins.config.lsp_mason').tool_installer_opts,
    },
    {
        'neovim/nvim-lspconfig',
    },
    {
        'stevearc/conform.nvim',
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        opts = require('plugins.config.format_conform').opts,
    },
    {
        'mfussenegger/nvim-lint',
        event = { "BufEnter", "BufWritePost", "InsertLeave" },
        config = require('plugins.config.lint_nvimlint').config,
    },
    -- }}}
    ---------------------------------------------------------------------------


    ---------------------------------------------------------------------------
    -- Autocomplete {{{
    ---------------------------------------------------------------------------
    {
        'milanglacier/minuet-ai.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
        lazy = false,
        config = function()
            require('minuet').setup {
                provider = 'openai_fim_compatible',
                n_completions = 1,
                context_window = 600,
                throttle = 300,
                debounce = 200,
                request_timeout = 10,
                provider_options = {
                    openai_fim_compatible = {
                        api_key = function() return 'ollama' end,
                        name = 'Ollama',
                        stream = true,
                        end_point = 'http://localhost:11434/v1/completions',
                        model = 'JetBrains/Mellum-4b-sft-all',
                        optional = {
                            max_tokens = 40,
                            top_p = 0.9,
                            temperature = 0,
                            num_ctx = 600,
                        },
                    },
                },
                virtualtext = {
                    auto_trigger_ft = { '*' },
                    keymap = {
                        accept = false,
                        accept_line = '<A-a>',
                        prev = '<A-[>',
                        next = '<A-]>',
                        dismiss = '<A-e>',
                    },
                },
            }
        end,
    },
    {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      -- cmp sources plugins
      {
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
      },
    },
    opts = function()
      return require('plugins.config.autocomplete_cmp').opts
    end,
    config = function(_, opts)
        local cmp = require("cmp")
        cmp.setup(opts)

        local cmdline_mapping = cmp.mapping.preset.cmdline({
            ['<C-Space>'] = { c = cmp.mapping.complete() },
            ['<C-n>'] = { c = cmp.mapping.select_next_item() },
            ['<C-p>'] = { c = cmp.mapping.select_prev_item() },
            ['<Tab>'] = { c = function()
                if cmp.visible() then
                    cmp.confirm({ select = true })
                else
                    cmp.complete()
                end
            end },
        })

        -- `/` and `?` search completion
        cmp.setup.cmdline({ '/', '?' }, {
            mapping = cmdline_mapping,
            completion = { autocomplete = { require('cmp.types').cmp.TriggerEvent.TextChanged } },
            sources = {
                { name = 'buffer' },
            },
        })

        -- `:` command line completion
        cmp.setup.cmdline(':', {
            mapping = cmdline_mapping,
            completion = { autocomplete = { require('cmp.types').cmp.TriggerEvent.TextChanged } },
            sources = cmp.config.sources({
                { name = 'path' },
            }, {
                { name = 'cmdline' },
            }),
            matching = { disallow_symbol_nonprefix_matching = false },
        })
    end,
  },
    -- }}}
    ---------------------------------------------------------------------------


    ---------------------------------------------------------------------------
    -- Utils {{{
    ---------------------------------------------------------------------------
    {
        'dstein64/vim-startuptime',
        init = require('plugins.config.utils_startuptime').init,
        cmd = 'StartupTime',
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {}
    },
    {
        'mikesmithgh/kitty-scrollback.nvim',
        enabled = true,
        lazy = true,
        cmd = { 'KittyScrollbackGenerateKittens', 'KittyScrollbackCheckHealth' },
        event = { 'User KittyScrollbackLaunch' },
        version = '*', -- latest stable version, may have breaking changes if major version changed
        config = function() require('kitty-scrollback').setup() end,
    },
    { "junegunn/fzf", build = "./install --bin" },
    {
        "ibhagwan/fzf-lua",
        dependencies = { "nvim-tree/nvim-web-devicons", "junegunn/fzf" },
        config = function() require("fzf-lua").setup() end
    },
    -- gitsigns
    {
        'lewis6991/gitsigns.nvim',
        -- dependencies = { 'tanvirtin/monokai.nvim' },
        config = require('plugins.config.utils_gitsigns').config,
    },
    -- }}}
    ---------------------------------------------------------------------------
}
