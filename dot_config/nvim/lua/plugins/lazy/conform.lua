return {
    {
        "stevearc/conform.nvim",
        event = { "BufReadPre", "BufNewFile" },
        keys = {
            {
                "<leader>mp",
                function()
                    require("conform").format({
                        lsp_fallback = true,
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
                            "--wrap-parameters", "after-first",
                            "--wrap-arguments", "after-first",
                        },
                    },
                },
                -- format_on_save = function(bufnr)
                --     return { timeout_ms = 500, lsp_fallback = true }
                -- end,
                log_level = vim.log.levels.ERROR,
            })
        end,
    },
}
