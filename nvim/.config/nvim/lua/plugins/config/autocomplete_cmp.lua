local cmp = require "cmp"
local compare = cmp.config.compare
local lspkind = require 'lspkind'
local M = {}

local function border(hl_name)
  return {
    { "╭", hl_name },
    { "─", hl_name },
    { "╮", hl_name },
    { "│", hl_name },
    { "╯", hl_name },
    { "─", hl_name },
    { "╰", hl_name },
    { "│", hl_name },
  }
end

M.opts = {
    view ={
        entries = {
            name = "custom", -- can be "custom", "wildmenu" or "native"
            selection_order = 'near_cursor',
        },
    },
  completion = {
    -- completeopt = "menu,menuone",
  },
  window = {
    completion = {
      side_padding = 1,
      -- winhighlight = "Normal:CmpPmenu,CursorLine:CmpSel,Search:None",
      scrollbar = true,
    },
    documentation = {
      border = border "CmpDocBorder",
      winhighlight = "Normal:CmpDoc",
    },
  },
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  formatting = {
      fields = { "abbr", "kind", "menu" },
      format = lspkind.cmp_format({
          mode = 'symbol_text', -- show only symbol annotations
          -- menu = ({
          --     buffer = "[Buffer]",
          --     nvim_lsp = "[LSP]",
          --     luasnip = "[LuaSnip]",
          --     nvim_lua = "[Lua]",
          --     copilot = "[Copilot]",
          --     cmp_tabnine = "[TabNine]",
          -- }),
          maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
                         -- can also be a function to dynamically calculate max width such as
                         -- maxwidth = function() return math.floor(0.45 * vim.o.columns) end,
          ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
          show_labelDetails = true, -- show labelDetails in menu. Disabled by default

          -- The function below will be called before any actual modifications from lspkind
          -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
          before = function (entry, vim_item)
            -- ...
            return vim_item
          end
      })
  },
  mapping = {
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<Esc>"] = cmp.mapping(function(fallback)
        cmp.mapping.close()
        fallback()
    end, { "i", "s" }),
    ["<CR>"] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    },
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        fallback()
      elseif require("luasnip").expand_or_jumpable() then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
      else
        fallback()
      end
    end, { "i", "s", }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        fallback()
      elseif require("luasnip").jumpable(-1) then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
      else
        fallback()
      end
    end, { "i", "s", }),
  },
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "copilot" },
    { name = "luasnip" },
    { name = 'cmp_tabnine' },
    { name = "nvim_lua" },
    { name = "path" },
  }, {
    { name = "buffer" },
  }),

  -- sorting = {
  --     comparators = {
  --         compare.kind,
  --         compare.sort_text,
  --     },
  -- },

  sorting = {
    priority_weight = 2,
    comparators = {
      require("copilot_cmp.comparators").prioritize,

      -- Below is the default comparitor list and order for nvim-cmp
      compare.offset,
      -- cmp.config.compare.scopes, --this is commented in nvim-cmp too
      compare.exact,
      compare.score,
      compare.recently_used,
      compare.locality,
      compare.kind,
      compare.sort_text,
      compare.length,
      compare.order,
    },
  },

  matching = {
      disallow_fuzzy_matching = true,
      disallow_fullfuzzy_matching = true,
      disallow_partial_fuzzy_matching = true,
      disallow_partial_matching = true,
      disallow_prefix_unmatching = true,
  }
}

M.luasnip = function(opts)
  require("luasnip").config.set_config(opts)

  -- vscode format
  require("luasnip.loaders.from_vscode").lazy_load()
  require("luasnip.loaders.from_vscode").lazy_load { paths = vim.g.vscode_snippets_path or "" }

  -- snipmate format
  require("luasnip.loaders.from_snipmate").load()
  require("luasnip.loaders.from_snipmate").lazy_load { paths = vim.g.snipmate_snippets_path or "" }

  -- lua format
  require("luasnip.loaders.from_lua").load()
  require("luasnip.loaders.from_lua").lazy_load { paths = vim.g.lua_snippets_path or "" }

  vim.api.nvim_create_autocmd("InsertLeave", {
    callback = function()
      if
        require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
        and not require("luasnip").session.jump_active
      then
        require("luasnip").unlink_current()
      end
    end,
  })
end

return M
