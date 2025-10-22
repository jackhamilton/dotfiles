return {
    'mrcjkb/rustaceanvim',
    ft = 'rust',
    dependencies = { 'saghen/blink.cmp' },
    init = function()
        vim.g.rustaceanvim = {
            server = {
                capabilities = require('blink.cmp').get_lsp_capabilities(),
                settings = {
                    ["rust-analyzer"] = {
                        files = {
                            exclude = {
                                "**/.direnv",
                                "**/target",
                                "_build",
                                ".dart_tool",
                                ".flatpak-builder",
                                ".git",
                                ".gitlab",
                                ".gitlab-ci",
                                ".gradle",
                                ".idea",
                                ".next",
                                ".project",
                                ".scannerwork",
                                ".settings",
                                ".venv",
                                "archetype-resources",
                                "bin",
                                "hooks",
                                "node_modules",
                                "po",
                                "screenshots",
                                "target"
                            }
                        }
                    },
                },
            },
        }
    end,
}
