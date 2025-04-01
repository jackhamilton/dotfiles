vim.diagnostic.config({
    virtual_lines = true,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = '',
            [vim.diagnostic.severity.WARN] = '',
        },
        linehl = {
            [vim.diagnostic.severity.ERROR] = '󰌵',
        },
        numhl = {
            [vim.diagnostic.severity.WARN] = '',
        },
    }
})

vim.lsp.config('*', { capabilities = require('blink.cmp').get_lsp_capabilities()})

vim.lsp.enable({
    'clangd',
    'sourcekit',
    'lua_ls'
})
