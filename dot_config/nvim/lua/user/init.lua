local on_attach = function(client, bufnr)
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', 'lr', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<space>lf', function() vim.lsp.buf.format { async = true } end, bufopts)
end

require 'lspconfig'.pyright.setup { on_attach = on_attach }
require 'lspconfig'.gdscript.setup { on_attach = on_attach }
require 'lspconfig'.sourcekit.setup {on_attach = on_attach }

-- if client.supports_method("textDocument/formatting") then
--     vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
--     vim.cmd("autocmd BufWritePre lua vim.lsp.buf.format()")
-- end

vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        --enable omnifunc completion
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        -- buffer local mappings
        local opts = { buffer = ev.buf }
        -- go to definition
        -- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        --puts doc header info into a float page
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'J', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)

        -- workspace management. Necessary for multi-module projects
        vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set('n', '<space>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)

        -- add LSP code actions
        vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)

        -- find references of a type
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    end,
})
