return {
    {
        "tris203/precognition.nvim",
        config = function()
            require("precognition").toggle()
        end,
        opts = {
            startVisible = true,
        },
        lazy = false
    },
}
