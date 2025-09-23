return {
    'mrcjkb/rustaceanvim',
    ft = 'rust',
    dependencies = { 'saghen/blink.cmp' },
    init = function()
        vim.g.rustaceanvim = {
            server = {
                capabilities = require('blink.cmp').get_lsp_capabilities(),
            },
        }
    end,
}
