return {
    {
        'smoka7/hop.nvim',
        version = "*",
        opts = {
            keys = 'arstneioqwfpluyzxcdhbgvjmk'
        },
        config = function(_, opts)
            require('hop').setup(opts)

            -- Hop normally turns the first line of a fold into an empty line,
            -- leaving only column zero available as a target. Keep that line's
            -- text so its markers remain useful, while still skipping the
            -- hidden lines in the folded region.
            local window = require('hop.window')
            window.get_lines_context = function(win_ctx)
                local lines = {}
                local lnr = win_ctx.line_range[1]

                while lnr <= win_ctx.line_range[2] do
                    local fold_end = vim.api.nvim_win_call(win_ctx.win_handle, function()
                        return vim.fn.foldclosedend(lnr)
                    end)
                    lines[#lines + 1] = {
                        row = lnr,
                        line = vim.api.nvim_buf_get_lines(win_ctx.buf_handle, lnr - 1, lnr, false)[1],
                        col_bias = 0,
                    }
                    if fold_end ~= -1 then lnr = fold_end end
                    lnr = lnr + 1
                end

                return lines
            end
        end,
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
                mode = "n",
                function()
                    require('hop-yank').yank_char1()
                end,
                desc = "Yank at character"
            },
            {
                "sP",
                mode = "n",
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
            {
                "sa",
                mode = { "n", "x", "o" },
                function()
                    require('hop').hop_anywhere()
                end,
                desc = "Hop Anywhere"
            },
        }
    },
}
