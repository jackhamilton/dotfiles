return {
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        event = "LspAttach",
        cmd = "Trouble",
        config = {
            auto_close = true,
            modes = {
                mydiags = {
                  mode = "diagnostics", -- inherit from diagnostics mode
                  filter = {
                    any = {
                      buf = 0, -- current buffer
                      {
                        severity = vim.diagnostic.severity.ERROR, -- errors only
                        -- limit to files in the current project
                        function(item)
                          return item.filename:find((vim.loop or vim.uv).cwd(), 1, true)
                        end,
                      },
                    },
                  },
                }
            }
        },
       keys = {
            {
                "<leader>xx",
                "<cmd>Trouble diagnostics toggle<cr>",
                desc = "Diagnostics (Trouble)",
            },
            {
                "<leader>xX",
                "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
                desc = "Buffer Diagnostics (Trouble)",
            },
            {
                "<leader>lL",
                "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
                desc = "All LSP relationships (Trouble)",
            },
            {
                "<leader>xL",
                "<cmd>Trouble loclist toggle<cr>",
                desc = "Location List (Trouble)",
            },
            {
                "<leader>qt",
                "<cmd>Trouble qflist toggle filter.severity=vim.diagnostic.severity.ERROR<cr>",
                desc = "Quickfix Errors (Trouble)",
            },
        },
    },
}
