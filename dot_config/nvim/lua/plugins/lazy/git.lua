return {
    -- {
    --     "akinsho/git-conflict.nvim",
    --     version = "*",
    --     config = true,
    -- },
    {
        'lewis6991/gitsigns.nvim',
        event = 'VimEnter',
        opts = {},
    },
    {
        "sindrets/diffview.nvim",
        version = "*",
        config = true,
    },
    {
        "NeogitOrg/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim",         -- required
            "sindrets/diffview.nvim",        -- optional - Diff integration

            "nvim-telescope/telescope.nvim", -- optional
        },
        keys = {
            { "<leader>gb", "<cmd>Neogit bisect<cr>", desc = "Bisect" },
            { "<leader>gB", "<cmd>Neogit branch_config<cr>", desc = "Branch config" },
            { "<leader>gC", "<cmd>Neogit cherry_pick<cr>", desc = "Cherrypick" },
            { "<leader>gc", "<cmd>Neogit commit<cr>", desc = "Commit" },
            { "<leader>gd", "<cmd>Neogit diff<cr>", desc = "Diff" },
            { "<leader>gf", "<cmd>Neogit fetch<cr>", desc = "Fetch" },
            { "<leader>gi", "<cmd>Neogit ignore<cr>", desc = "Ignore" },
            { "<leader>gl", "<cmd>Neogit log<cr>", desc = "Log" },
            { "<leader>gm", "<cmd>Neogit merge<cr>", desc = "Merge" },
            { "<leader>gp", "<cmd>Neogit pull<cr>", desc = "Pull" },
            { "<leader>gP", "<cmd>Neogit push<cr>", desc = "Push" },
            { "<leader>grr", "<cmd>Neogit rebase<cr>", desc = "Rebase" },
            { "<leader>grc", "<cmd>Neogit remote_config<cr>", desc = "Remote config" },
            { "<leader>gre", "<cmd>Neogit remote<cr>", desc = "Remote" },
            { "<leader>grs", "<cmd>Neogit reset<cr>", desc = "Reset" },
            { "<leader>grv", "<cmd>Neogit revert<cr>", desc = "Revert" },
            { "<leader>gs", "<cmd>Neogit stash<cr>", desc = "Stash" },
            { "<leader>gt", "<cmd>Neogit tag<cr>", desc = "Tag" },
            { "<leader>gw", "<cmd>Neogit worktree<cr>", desc = "Worktree" },
        },
        config = true
    },
}
