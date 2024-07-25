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
        config = true
    },
}
