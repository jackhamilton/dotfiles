return {
    {
        "sindrets/diffview.nvim",
        keys = {
            { "<leader>gD", function() vim.cmd('DiffviewOpen main --cached') end, desc = "Diff with main"},
        },
    }
}
