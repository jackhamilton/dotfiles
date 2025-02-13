local function get_sourcekit()
    local mac = vim.fn.OSX()
    if mac == 1 then
        return {
            cmd = { "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/sourcekit-lsp" },
            -- root_dir = require 'lspconfig'.util.root_pattern("Package.swift", ".git"),
            capabilities = {
                workspace = {
                    didChangeWatchedFiles = {
                        dynamicRegistration = true
                    }
                }
            },
            filetypes = { "swift" },
        }
    else
        return {
            capabilities = {
                workspace = {
                    didChangeWatchedFiles = {
                        dynamicRegistration = true
                    }
                }
            },
            -- root_dir = require 'lspconfig'.util.root_pattern("Package.swift"),
            filetypes = { "swift" },
        }
    end
end

return {
    {
        'neovim/nvim-lspconfig',
        dependencies = { 'saghen/blink.cmp' },
        opts = {
            servers = {
                lua_ls = {},
                sourcekit = get_sourcekit(),
                gdscript = {
                    name = "godot",
                    cmd = vim.lsp.rpc.connect("127.0.0.1", "6005"),
                },
            }
        },
        config = function(_, opts)
            local lspconfig = require('lspconfig')
            for server, config in pairs(opts.servers) do
                -- passing config.capabilities to blink.cmp merges with the capabilities in your
                -- `opts[server].capabilities, if you've defined it
                config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
                lspconfig[server].setup(config)
            end
        end
    },
}
