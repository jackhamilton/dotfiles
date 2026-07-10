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

vim.lsp.config('sourcekit', {
    root_dir = function(bufnr, on_dir)
        local path = vim.fs.normalize(vim.api.nvim_buf_get_name(bufnr))
        local cwd = vim.fs.normalize(vim.fn.getcwd())
        local cwd_is_workspace = vim.uv.fs_stat(cwd .. '/Package.swift')
            or vim.uv.fs_stat(cwd .. '/buildServer.json')

        if not cwd_is_workspace then
            for name in vim.fs.dir(cwd) do
                if name:match('%.xcworkspace$') or name:match('%.xcodeproj$') then
                    cwd_is_workspace = true
                    break
                end
            end
        end

        local root = vim.fs.relpath(cwd, path) and cwd_is_workspace and cwd
            or vim.fs.root(path, 'Package.swift')
            or vim.fs.root(path, 'buildServer.json')
            or vim.fs.root(path, function(name)
                return name:match('%.xcworkspace$') or name:match('%.xcodeproj$')
            end)
            or vim.fs.root(path, '.git')

        on_dir(root)
    end,
})

vim.lsp.enable({
    'clangd',
    'sourcekit',
    'lua_ls',
    'nixd',
    'ts_ls',
    'yamlls',
})

vim.lsp.config('nixd', {
   settings = {
      nixd = {
         formatting = {
            command = { "nixfmt" },
         },
      },
   },
})
