return {
    "johmsalas/text-case.nvim",
    keys = {
        { "<leader>Clu", function () require('textcase').lsp_rename('to_upper_case') end, desc = "LSP UPPERCASE" },
        { "<leader>Cll", function () require('textcase').lsp_rename('to_lower_case') end, desc = "LSP lowercase" },
        { "<leader>Cls", function () require('textcase').lsp_rename('to_snake_case') end, desc = "LSP snake_case" },
        { "<leader>Cld", function () require('textcase').lsp_rename('to_dash_case') end, desc = "LSP dash-case" },
        { "<leader>ClC", function () require('textcase').lsp_rename('to_constant_case') end, desc = "LSP CONSTANT_CASE" },
        { "<leader>Clc", function () require('textcase').lsp_rename('to_camel_case') end, desc = "LSP camelCase" },

        { "<leader>Cu", function () require('textcase').current_word('to_upper_case') end, desc = "Convert to UPPERCASE" },
        { "<leader>CL", function () require('textcase').current_word('to_lower_case') end, desc = "Convert to lowercase" },
        { "<leader>Cs", function () require('textcase').current_word('to_snake_case') end, desc = "Convert to snake_case" },
        { "<leader>Cd", function () require('textcase').current_word('to_dash_case') end, desc = "Convert to dash-case" },
        { "<leader>CC", function () require('textcase').current_word('to_constant_case') end, desc = "Convert to CONSTANT_CASE" },
        { "<leader>Cc", function () require('textcase').current_word('to_camel_case') end, desc = "Convert to camelCase" },
    }
}
