return {
    {
        "stevearc/conform.nvim",
        event = { "BufReadPre", "BufNewFile" },
        keys = {
            {
                "<leader>mp",
                function()
                    require("conform").format({
                        lsp_format = "fallback",
                        async = false,
                        timeout_ms = 500,
                    })
                end,
                mode = { "n", "x" },
                desc = "Format file or range (in visual mode)",
            },
        },
        config = function()
            local conform = require("conform")

            conform.setup({
                formatters_by_ft = {
                    swift = { "swiftformat" },
                },
                formatters = {
                    swiftformat = {
                        prepend_args = {
                            "--allman", "false",
                            "--disable", "wrapMultilineStatementBraces",
                            "--max-width", "120",
                            "--wrap-parameters", "preserve",
                            "--allow-partial-wrapping", "false",
                            "--wrap-arguments", "preserve",
                        },
                    },
                },
                -- format_on_save = function(bufnr)
                --     return { timeout_ms = 500, lsp_format = "fallback" }
                -- end,
                log_level = vim.log.levels.ERROR,
            })
        end,
    },
}
