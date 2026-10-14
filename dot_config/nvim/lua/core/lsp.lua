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

local xcode_project_by_root = {}
local generated_directories = {
    '.build',
    '.swiftpm',
    'DerivedData',
    'Pods',
    'Carthage',
    'node_modules',
}

local function has_xcode_project(git_root)
    if xcode_project_by_root[git_root] ~= nil then
        return xcode_project_by_root[git_root]
    end

    local git_command = {
        'git',
        '-C',
        git_root,
        'ls-files',
        '--cached',
        '--others',
        '--exclude-standard',
    }

    for _, directory in ipairs(generated_directories) do
        table.insert(git_command, '--exclude=**/' .. directory .. '/**')
    end

    local files = vim.fn.systemlist(git_command)
    local has_project = false

    for _, file in ipairs(files) do
        if file:match('^project%.pbxproj$')
            or file:match('/project%.pbxproj$')
            or file:match('^[^/]+%.xcworkspace/')
            or file:match('/[^/]+%.xcworkspace/')
        then
            has_project = true
            break
        end
    end

    xcode_project_by_root[git_root] = has_project
    return has_project
end

vim.lsp.config('sourcekit', {
    -- Prevent recursive Swift watchers from exhausting file descriptors in large workspaces.
    capabilities = {
        workspace = {
            didChangeWatchedFiles = {
                dynamicRegistration = false,
            },
        },
    },
    root_dir = function(bufnr, on_dir)
        local path = vim.fs.normalize(vim.api.nvim_buf_get_name(bufnr))
        local git_root = vim.fs.root(path, '.git')
        local is_xcode_project = git_root and has_xcode_project(git_root)

        local root = is_xcode_project and git_root
            or vim.fs.root(path, 'Package.swift')
            or git_root

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
    'action_ls',
    "gh_actions_ls"
})

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.name == 'sourcekit' then
            require('utils.lsp_references').wrap_client(client)
        end
    end,
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
