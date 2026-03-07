local M = {}

M.config = function()
    require("gitsigns").setup({
          signcolumn = auto,
          current_line_blame = true,
          current_line_blame_opts = {
            delay = 1000,
            virt_text_pos = "right_align", -- 'eol' | 'overlay' | 'right_align'
          },
          on_attach = function(bufnr)
              vim.wo.signcolumn = "yes"
          end,
    })
end

return M
