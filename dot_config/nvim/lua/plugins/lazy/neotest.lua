return {
    {
        "nvim-neotest/neotest",
        event = "LspAttach",
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-neotest/neotest-plenary",
            "rouge8/neotest-rust",
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter"
        },
        config = function()
            require("neotest").setup({
                adapters = {
                    require("neotest-plenary"),
                    require("neotest-rust")
                }
            })
        end,
        keys = {
            { "<leader>Dr", desc = "Run test" },
            { "<leader>Drn", function() require("neotest").run.run() end, desc = "Run nearest test" },
            { "<leader>Drf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run test file" },
            { "<leader>Drd", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Debug nearest test" },
            { "<leader>Drs", function() require("neotest").run.stop() end, desc = "Stop test" },
        }
    }
}
