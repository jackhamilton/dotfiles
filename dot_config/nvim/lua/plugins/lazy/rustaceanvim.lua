return {
    'mrcjkb/rustaceanvim',
    ft = 'rust',
    dependencies = { 'saghen/blink.cmp' },
    init = function()
        vim.g.rustaceanvim = function()
            local root = vim.fs.root(0, 'Cargo.toml')
            local use_workspace_clippy = root and vim.fn.filereadable(root .. '/.nvim-lint-workspace') == 1

            return {
                server = {
                    default_settings = {
                        ["rust-analyzer"] = {
                            checkOnSave = true,
                            check = {
                                command = use_workspace_clippy and "clippy" or "check",
                                extraArgs = use_workspace_clippy and {
                                    "--workspace",
                                    "--all-targets",
                                    "--all-features",
                                } or nil,
                            },
                            files = {
                                watcher = "client",
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
        end
    end,
}
