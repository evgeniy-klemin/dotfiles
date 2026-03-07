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
    { 'preservim/tagbar' },
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
        'nvimtools/none-ls.nvim',
        requires = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
        opts = function() return require('plugins.config.lsp_null_ls').opts end,
    },
    -- }}}
    ---------------------------------------------------------------------------


    ---------------------------------------------------------------------------
    -- Autocomplete {{{
    ---------------------------------------------------------------------------
    -- { 'github/copilot.vim' },
    {
        'zbirenbaum/copilot.lua',
        config = function()
            require("copilot").setup({
                suggestion = {
                    auto_trigger = true,
                    keymap = {
                      accept = false,
                      accept_word = false,
                      accept_line = false,
                      next = "<C-]>",
                      prev = "<C-[>",
                      dismiss = "<C-x>",
                    },
                },
            })
            -- super tab - accept suggestion or do normal tab
            vim.keymap.set("i", '<Tab>', function()
              if require("copilot.suggestion").is_visible() then
                require("copilot.suggestion").accept()
              else
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
              end
            end, {
              silent = true,
            })
        end,
    },
    {
        "zbirenbaum/copilot-cmp",
        dependencies = { 'zbirenbaum/copilot.lua' },
        config = function () require("copilot_cmp").setup() end,
    },
    {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "zbirenbaum/copilot-cmp",
      {
        -- snippet plugin
        "L3MON4D3/LuaSnip",
        dependencies = "rafamadriz/friendly-snippets",
        opts = { history = true, updateevents = "TextChanged,TextChangedI" },
        config = function(_, opts)
          require('plugins.config.autocomplete_cmp').luasnip(opts)
          vim.api.nvim_set_hl(0, "CmpItemKindCopilot", {fg ="#6CC644"})
        end,
      },

      -- autopairing of (){}[] etc
      -- {
      --   "windwp/nvim-autopairs",
      --   opts = {
      --     fast_wrap = {},
      --     disable_filetype = { "TelescopePrompt", "vim" },
      --   },
      --   config = function(_, opts)
      --     require("nvim-autopairs").setup(opts)
      --
      --     -- setup cmp for autopairs
      --     local cmp_autopairs = require "nvim-autopairs.completion.cmp"
      --     require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
      --   end,
      -- },


      -- tabnine autocomplete
      {
         'tzachar/cmp-tabnine',
         build = './install.sh',
         dependencies = 'hrsh7th/nvim-cmp',
         config = function()
            require('cmp_tabnine.config'):setup({
                max_lines = 1000,
                max_num_results = 20,
                sort = true,
                run_on_every_keystroke = true,
                snippet_placeholder = '..',
                ignored_file_types = {
                    -- default is not to ignore
                    -- uncomment to ignore in lua:
                    -- lua = true
                },
                show_prediction_strength = false
            })
         end,
     },

      -- cmp sources plugins
      {
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
      },
    },
    opts = function()
      return require('plugins.config.autocomplete_cmp').opts
    end,
    config = function(_, opts)
        require("cmp").setup(opts)
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
