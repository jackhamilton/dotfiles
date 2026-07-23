return {
    {
        "retran/meow.yarn.nvim",
        dependencies = { "MunifTanjim/nui.nvim" },
        opts = {},
        keys = {
            {
                "<leader>lyi",
                function() require("meow.yarn").open_tree("call_hierarchy", "callers") end,
                desc = "Incoming calls",
            },
            {
                "<leader>lyo",
                function() require("meow.yarn").open_tree("call_hierarchy", "callees") end,
                desc = "Outgoing calls",
            },
            {
                "<leader>lys",
                function() require("meow.yarn").open_tree("type_hierarchy", "subtypes") end,
                desc = "Subtypes",
            },
            {
                "<leader>lyS",
                function() require("meow.yarn").open_tree("type_hierarchy", "supertypes") end,
                desc = "Supertypes",
            },
            {
                "<leader>lyr",
                function() require("meow.yarn").reopen_last() end,
                desc = "Reopen last hierarchy",
            },
        },
    },
}
