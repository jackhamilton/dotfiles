return {
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        event = "LspAttach",
        cmd = "Trouble",
        config = function()
            require('trouble').setup {}
            local wk = require('which-key')
            wk.add({
                { "<leader>x",  group = "Trouble" },
                { "<leader>xL", "<cmd>Trouble loclist toggle<cr>",                            desc = "Location List (Trouble)" },
                { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>",                             desc = "Quickfix List (Trouble)" },
                { "<leader>xX", "<cmd>Trouble diagnostics toggle filter<cr>",                 desc = "Buffer Diagnostics (Trouble)" },
                { "<leader>xl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP Definitions / references / ... (Trouble)" },
                { "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>",                desc = "Symbols (Trouble)" },
                { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",                        desc = "Diagnostics (Trouble)" },
            })
        end,
    },
}
