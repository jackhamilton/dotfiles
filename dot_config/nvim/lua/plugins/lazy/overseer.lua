return {
    {
        "stevearc/overseer.nvim",
        opts = {},
        keys = {
            {
                "<leader>lb",
                function()
                    local overseer = require("overseer")
                    overseer.run_task({ tags = { overseer.TAG.BUILD } })
                end,
                desc = "Build project",
            },
            {
                "<leader>lO",
                "<cmd>OverseerRun<cr>",
                desc = "Select project task",
            },
        },
    },
}
