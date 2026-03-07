local M = {}

M.config = function()
    local builtin = require('statuscol.builtin')
    local cfg = {
        relculright = true,
        segments = {
            { text = { builtin.foldfunc }, click = 'v:lua.ScFa' },
            {
                sign = { name = { 'Diagnostic' }, maxwidth = 1, auto = true },
                click = 'v:lua.ScSa'

            },
            {
                text = { builtin.lnumfunc },
                click = 'v:lua.ScLa'
            },
            {
                sign = { namespace = { "gitsign*" }, maxwidth = 1 },
                click = "v:lua.ScSa"
            },
            {
              sign = { name = { "Dap" }, maxwidth = 1, auto = true },
              click = "v:lua.ScSa",
            },
        }
    }
    require('statuscol').setup(cfg)
end

return M
