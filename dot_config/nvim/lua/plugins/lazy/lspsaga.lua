return {
    {
        "nvimdev/lspsaga.nvim",
        config = true,
        event = 'LspAttach',
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },
        keys = {
            { "<leader>Lf",  mode = { "n" }, "<CMD>Lspsaga finder<CR>",                   desc = "Finder" },
            { "<leader>Lci", mode = { "n" }, "<CMD>Lspsaga incoming_calls<CR>",           desc = "Incoming Calls" },
            { "<leader>Lco", mode = { "n" }, "<CMD>Lspsaga outgoing_calls<CR>",           desc = "Outgoing Calls" },
            { "<leader>La",  mode = { "n" }, "<CMD>Lspsaga code_actions<CR>",             desc = "Code Actions" },
            { "<leader>Ld",  mode = { "n" }, "<CMD>Lspsaga peek_definition<CR>",          desc = "Peek Definition" },
            { "<leader>LD",  mode = { "n" }, "<CMD>Lspsaga peek_type_definition<CR>",     desc = "Peek Type Definition" },
            { "<leader>Ln",  mode = { "n" }, "<CMD>Lspsaga diagnostic_jump_next<CR>",     desc = "Next Diagnostic" },
            { "<leader>Lp",  mode = { "n" }, "<CMD>Lspsaga diagnostic_jump_previous<CR>", desc = "Previous Diagnostic" },
            { "<leader>Lt",  mode = { "n" }, "<CMD>Lspsaga term_toggle<CR>",              desc = "Toggle Terminal" },
            { "<leader>Lh",  mode = { "n" }, "<CMD>Lspsaga hover_doc<CR>",                desc = "Hover Documentation" },
            { "<leader>Lo",  mode = { "n" }, "<CMD>Lspsaga outline<CR>",                  desc = "Outline" },
            { "<leader>Lr",  mode = { "n" }, "<CMD>Lspsaga rename<CR>",                   desc = "Rename" },
            { "<leader>Li",  mode = { "n" }, "<CMD>Lspsaga incoming_calls<CR>",           desc = "Incoming Calls" },
        },
    },
}
