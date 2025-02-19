return {
    {
        'smoka7/hop.nvim',
        version = "*",
        opts = {
 arstgmneio           keys = 'arstgmneioxcdhwfpluy',
        },
        keys = {
            {
                "sc",
                mode = { "n", "x", "o" },
                function()
                    require('hop').hint_char1()
                end,
                desc = "Hop to character"
            },
            {
                "ss",
                mode = { "n", "x", "o" },
                function()
                    require('hop').hint_char2()
                end,
                desc = "Hop to two characters"
            },
            {
                "sl",
                mode = { "n", "x", "o" },
                function()
                    require('hop').hint_lines_skip_whitespace()
                end,
                desc = "Hop to line"
            },
            {
                "sp",
                mode = { "n", "x", "o" },
                function()
                    require('hop').hint_patterns()
                end,
                desc = "Hop to pattern"
            },
            {
                "sw",
                mode = { "n", "x", "o" },
                function()
                    require('hop').hint_words()
                end,
                desc = "Hop to word"
            },
            {
                "sy",
                mode = { "n", "x", "o" },
                function()
                    require('hop-yank').yank_char1()
                end,
                desc = "Yank at character"
            },
            {
                "sp",
                mode = { "n", "x", "o" },
                function()
                    require('hop-yank').paste_char1()
                end,
                desc = "Paste at character"
            },
            {
                "st",
                mode = { "n", "x", "o" },
                function()
                    require('hop-treesitter').hint_nodes()
                end,
                desc = "Hop to treesitter obj"
            },
        }
    },
}
