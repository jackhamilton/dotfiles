return {
    {
        "tris203/precognition.nvim",
        opts = {
            startVisible = false,
        },
        keys = {
            { "<leader>tP", function() require("precognition").toggle() end, desc = "Precognition"},
        },
        lazy = false
    },
}
