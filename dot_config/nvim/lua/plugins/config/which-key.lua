local wk = require("which-key")

wk.add({
    { "<leader>h", group = "History" },
    { "<leader>b", group = "Buffers"},
    { "<leader>i", group = "Indents"},
    { "<leader>lS", group = "Scope"},
    { "<leader>t", group = "Toggle" },
    { "<leader>l", group = "LSP" },
    { "<leader>D", group = "Debug" },
    { "<leader>Dn", group = "Tests" },
    { "<leader>f", group = "Files" },
    { "<leader>g", group = "Git" },
    { "<leader>m", group = "Format" },
    { "<leader>s", group = "Picker" },
    { "<leader>S", group = "Surround" },
    { "<leader>u", group = "Colorschemes" },

    { "<leader>ls", group = "Show" },
    { "<leader>lc", group = "Calls" },
    { "<leader>lg", group = "Goto" },
})
