return {
    {
        'echasnovski/mini.nvim',
        version = false,
        keys = {
            {
                "Sn",
                function() require("mini.surround").update_n_lines() end,
                desc = "Update surround search lines",
            },
        },
    },
}
