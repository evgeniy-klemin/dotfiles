#!/bin/bash
# Run nvim :checkhealth in headless mode and print results
# Usage: ./scripts/nvim-checkhealth.sh

OUTPUT="$HOME/nvim-ch.txt"

HOME="$HOME" /usr/local/bin/nvim --headless -c 'lua vim.defer_fn(function()
  vim.cmd("checkhealth")
  vim.defer_fn(function()
    local buf = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    local f = io.open(vim.fn.expand("~/nvim-ch.txt"), "w")
    for _, l in ipairs(lines) do f:write(l .. "\n") end
    f:close()
    os.exit(0)
  end, 10000)
end, 3000)' 2>/dev/null &

NVIM_PID=$!
sleep 20
kill $NVIM_PID 2>/dev/null
command cat "$OUTPUT" 2>/dev/null
