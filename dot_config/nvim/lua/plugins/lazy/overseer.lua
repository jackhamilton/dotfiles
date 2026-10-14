return {
    {
        "stevearc/overseer.nvim",
        opts = {},
        keys = {
            {
                "<leader>ob",
                function()
                    local overseer = require("overseer")
                    overseer.run_task({ tags = { overseer.TAG.BUILD } })
                end,
                desc = "Build project",
            },
            {
                "<leader>or",
                function()
                    require("overseer").run_task({ first = false })
                end,
                desc = "Select project task",
            },
            {
                "<leader>ot",
                "<cmd>OverseerToggle<cr>",
                desc = "Toggle project tasks",
            },
        },
    },
}
