return {
    {
        'smoka7/hop.nvim',
        version = "*",
        opts = {
            keys = 'arstgmneioxcdhwfpluy',
        },
        keys = {
            {
                "sc",
                mode = { "n", "x", "o" },
                function()
                    local directions = require("hop.hint").HintDirection
                    require('hop').hint_char1({ direction = directions.AFTER_CURSOR })
                end,
                desc = "Hop to character"
            },
            {
                "sC",
                mode = { "n", "x", "o" },
                function()
                    local directions = require("hop.hint").HintDirection
                    require('hop').hint_char1({ direction = directions.BEFORE_CURSOR })
                end,
                desc = "Hop to character"
            },
            {
                "ss",
                mode = { "n", "x", "o" },
                function()
                    local directions = require("hop.hint").HintDirection
                    require('hop').hint_char2({ direction = directions.AFTER_CURSOR })
                end,
                desc = "Hop to two characters"
            },
            {
                "sS",
                mode = { "n", "x", "o" },
                function()
                    local directions = require("hop.hint").HintDirection
                    require('hop').hint_char2({ direction = directions.BEFORE_CURSOR })
                end,
                desc = "Hop to two characters"
            },
            {
                "sl",
                mode = { "n", "x", "o" },
                function()
                    local directions = require("hop.hint").HintDirection
                    require('hop').hint_lines_skip_whitespace({ direction = directions.AFTER_CURSOR })
                end,
                desc = "Hop to line"
            },
            {
                "sL",
                mode = { "n", "x", "o" },
                function()
                    local directions = require("hop.hint").HintDirection
                    require('hop').hint_lines_skip_whitespace({ direction = directions.BEFORE_CURSOR })
                end,
                desc = "Hop to line"
            },
            {
                "sp",
                mode = { "n", "x", "o" },
                function()
                    local directions = require("hop.hint").HintDirection
                    require('hop').hint_patterns({ direction = directions.AFTER_CURSOR })
                end,
                desc = "Hop to pattern"
            },
            {
                "sP",
                mode = { "n", "x", "o" },
                function()
                    local directions = require("hop.hint").HintDirection
                    require('hop').hint_patterns({ direction = directions.BEFORE_CURSOR })
                end,
                desc = "Hop to pattern"
            },
            {
                "sw",
                mode = { "n", "x", "o" },
                function()
                    local directions = require("hop.hint").HintDirection
                    require('hop').hint_words({ direction = directions.AFTER_CURSOR })
                end,
                desc = "Hop to word"
            },
            {
                "sW",
                mode = { "n", "x", "o" },
                function()
                    local directions = require("hop.hint").HintDirection
                    require('hop').hint_words({ direction = directions.BEFORE_CURSOR })
                end,
                desc = "Hop to word"
            },
            {
                "sy",
                mode = { "n", "x", "o" },
                function()
                    local directions = require("hop.hint").HintDirection
                    require('hop-yank').yank_char1({ direction = directions.AFTER_CURSOR })
                end,
                desc = "Yank at character"
            },
            {
                "sY",
                mode = { "n", "x", "o" },
                function()
                    local directions = require("hop.hint").HintDirection
                    require('hop-yank').yank_char1({ direction = directions.BEFORE_CURSOR })
                end,
                desc = "Yank at character"
            },
            {
                "sp",
                mode = { "n", "x", "o" },
                function()
                    local directions = require("hop.hint").HintDirection
                    require('hop-yank').paste_char1({ direction = directions.AFTER_CURSOR })
                end,
                desc = "Paste at character"
            },
            {
                "sP",
                mode = { "n", "x", "o" },
                function()
                    local directions = require("hop.hint").HintDirection
                    require('hop-yank').paste_char1({ direction = directions.BEFORE_CURSOR })
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
