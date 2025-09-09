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
                        keymaps = {
                            -- Built-in captures.
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",

                            ["aA"] = "@assignment.outer",
                            ["iA"] = "@assignment.inner",

                            ["ab"] = "@block.outer",
                            ["ib"] = "@block.inner",

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
		    "OXY2DEV/markview.nvim",
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
