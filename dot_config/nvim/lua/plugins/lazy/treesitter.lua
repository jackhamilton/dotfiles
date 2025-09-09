return {
    {
        'nvim-treesitter/nvim-treesitter',
        lazy = false,
        config = function()
            require('nvim-treesitter').setup()
            require('nvim-treesitter.configs').setup({
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true,
                        keymaps = {
                            -- Built-in captures.
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",

                            ["aA"] = "@assignment.outer",
                            ["iA"] = "@assignment.inner",

                            ["aB"] = "@block.outer",
                            ["iB"] = "@block.inner",

                            ["ac"] = "@call.outer",
                            ["ic"] = "@call.inner",

                            ["aC"] = "@class.outer",
                            ["iC"] = "@class.inner",

                            ["a/"] = "@comment.outer",
                            ["i/"] = "@comment.inner",

                            ["a?"] = "@conditional.outer",
                            ["i?"] = "@conditional.inner",

                            ["ar"] = "@return.outer",
                            ["ir"] = "@return.inner",

                            ["an"] = "@number.outer",
                            ["in"] = "@number.inner",

                            ["al"] = "@loop.outer",
                            ["il"] = "@loop.inner",

                            ["aa"] = "@parameter.outer",
                            ["ia"] = "@parameter.inner",

                            ["as"] = "@statement.outer",
                        },
                    },
                    move = {
                        enable = true,
                        set_jumps = true, -- whether to set jumps in the jumplist
                        goto_next_start = {
                            ["]of"] = "@function.outer",
                            ["]oA"] = "@assignment.outer",
                            ["]oB"] = "@block.outer",
                            ["]oc"] = "@call.outer",
                            ["]oC"] = "@class.outer",
                            ["]o/"] = "@comment.outer",
                            ["]o?"] = "@conditional.outer",
                            ["]or"] = "@return.outer",
                            ["]on"] = "@number.outer",
                            ["]ol"] = "@loop.outer",
                            ["]oa"] = "@parameter.outer",
                            ["]os"] = "@statement.outer",
                        },
                        goto_next_end = {
                            ["]Of"] = "@function.outer",
                            ["]OA"] = "@assignment.outer",
                            ["]OB"] = "@block.outer",
                            ["]Oc"] = "@call.outer",
                            ["]OC"] = "@class.outer",
                            ["]O/"] = "@comment.outer",
                            ["]O?"] = "@conditional.outer",
                            ["]Or"] = "@return.outer",
                            ["]On"] = "@number.outer",
                            ["]Ol"] = "@loop.outer",
                            ["]Oa"] = "@parameter.outer",
                            ["]Os"] = "@statement.outer",
                        },
                        goto_previous_start = {
                            ["[of"] = "@function.outer",
                            ["[oA"] = "@assignment.outer",
                            ["[oB"] = "@block.outer",
                            ["[oc"] = "@call.outer",
                            ["[oC"] = "@class.outer",
                            ["[o/"] = "@comment.outer",
                            ["[o?"] = "@conditional.outer",
                            ["[or"] = "@return.outer",
                            ["[on"] = "@number.outer",
                            ["[ol"] = "@loop.outer",
                            ["[oa"] = "@parameter.outer",
                            ["[os"] = "@statement.outer",
                        },
                        goto_previous_end = {
                            ["[Of"] = "@function.outer",
                            ["[OA"] = "@assignment.outer",
                            ["[OB"] = "@block.outer",
                            ["[Oc"] = "@call.outer",
                            ["[OC"] = "@class.outer",
                            ["[O/"] = "@comment.outer",
                            ["[O?"] = "@conditional.outer",
                            ["[Or"] = "@return.outer",
                            ["[On"] = "@number.outer",
                            ["[Ol"] = "@loop.outer",
                            ["[Oa"] = "@parameter.outer",
                            ["[Os"] = "@statement.outer",
                        },
                    },
                    swap = {
                        enable = true,
                        swap_next = {
                            ["<leader>eaf"] = "@function.outer",
                            ["<leader>eif"] = "@function.inner",

                            ["<leader>eaA"] = "@assignment.outer",
                            ["<leader>eiA"] = "@assignment.inner",

                            ["<leader>eaB"] = "@block.outer",
                            ["<leader>eiB"] = "@block.inner",

                            ["<leader>eac"] = "@call.outer",
                            ["<leader>eic"] = "@call.inner",

                            ["<leader>eaC"] = "@class.outer",
                            ["<leader>eiC"] = "@class.inner",

                            ["<leader>ea/"] = "@comment.outer",
                            ["<leader>ei/"] = "@comment.inner",

                            ["<leader>ea?"] = "@conditional.outer",
                            ["<leader>ei?"] = "@conditional.inner",

                            ["<leader>ear"] = "@return.outer",
                            ["<leader>eir"] = "@return.inner",

                            ["<leader>ean"] = "@number.outer",
                            ["<leader>ein"] = "@number.inner",

                            ["<leader>eal"] = "@loop.outer",
                            ["<leader>eil"] = "@loop.inner",

                            ["<leader>eaa"] = "@parameter.outer",
                            ["<leader>eia"] = "@parameter.inner",

                            ["<leader>eas"] = "@statement.outer",
                        },
                        swap_previous = {
                            ["<leader>Eaf"] = "@function.outer",
                            ["<leader>Eif"] = "@function.inner",

                            ["<leader>EaA"] = "@assignment.outer",
                            ["<leader>EiA"] = "@assignment.inner",

                            ["<leader>EaB"] = "@block.outer",
                            ["<leader>EiB"] = "@block.inner",

                            ["<leader>Eac"] = "@call.outer",
                            ["<leader>Eic"] = "@call.inner",

                            ["<leader>EaC"] = "@class.outer",
                            ["<leader>EiC"] = "@class.inner",

                            ["<leader>Ea/"] = "@comment.outer",
                            ["<leader>Ei/"] = "@comment.inner",

                            ["<leader>Ea?"] = "@conditional.outer",
                            ["<leader>Ei?"] = "@conditional.inner",

                            ["<leader>Ear"] = "@return.outer",
                            ["<leader>Eir"] = "@return.inner",

                            ["<leader>Ean"] = "@number.outer",
                            ["<leader>Ein"] = "@number.inner",

                            ["<leader>Eal"] = "@loop.outer",
                            ["<leader>Eil"] = "@loop.inner",

                            ["<leader>Eaa"] = "@parameter.outer",
                            ["<leader>Eia"] = "@parameter.inner",

                            ["<leader>Eas"] = "@statement.outer",
                        },
                    },
                },
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
                indent = {
                    enable = true,
                }
            })
        end,
        dependencies = {
		    "<leader>eOXY2DEV/markview.nvim",
        }
    },
    {
        'nvim-treesitter/nvim-treesitter-context',
        lazy = false,
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
        },
    },
    {
        'nvim-treesitter/nvim-treesitter-textobjects',
        lazy = false,
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
        },
    }
}
