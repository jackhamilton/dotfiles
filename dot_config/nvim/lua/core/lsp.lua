vim.diagnostic.config({
    virtual_lines = true,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = '',
            [vim.diagnostic.severity.WARN] = '',
            [vim.diagnostic.severity.INFO] = '󰌵',
            [vim.diagnostic.severity.HINT] = '',
        },
    }
})

vim.lsp.config('*', { capabilities = require('blink.cmp').get_lsp_capabilities()})

vim.lsp.enable({
    'clangd',
    'sourcekit',
    'lua_ls'
})
