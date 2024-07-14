return {
    {
        'williamboman/mason.nvim',
        config = function(_, opts)
            require('mason').setup(opts)
            local mr = require('mason-registry')
            local function ensure_installed()
                for _, tool in ipairs(opts.ensure_installed) do
                    local p = mr.get_package(tool)
                    if not p:is_installed() then p:install() end
                end
            end
            if mr.refresh then
                mr.refresh(ensure_installed)
            else
                ensure_installed()
            end
        end,
        opts = { ensure_installed = {}, max_concurrent_installers = #vim.loop.cpu_info(), pip = { upgrade_pip = true } },
        build = ':MasonUpdate',
    },
    -- {
    --     'williamboman/mason-lspconfig.nvim',
    --     config = function(_, opts)
    --         require("mason-lspconfig").setup(opts)
    --     end,
    --     dependencies = {
    --         'williamboman/mason.nvim',
    --     },
    --     opts = { ensure_installed = {}, automatic_installation = true },
    -- },
}
