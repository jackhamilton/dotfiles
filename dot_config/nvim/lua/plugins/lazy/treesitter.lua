local function move_textobject(lhs, method, capture, description)
    vim.keymap.set({ "n", "x", "o" }, lhs, function()
        require("nvim-treesitter-textobjects.move")[method](capture, "textobjects")
    end, { desc = description })
end

return {
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        build = ":TSUpdate",
        config = function()
            local group = vim.api.nvim_create_augroup("treesitter_features", { clear = true })

            vim.api.nvim_create_autocmd("FileType", {
                group = group,
                pattern = "*",
                callback = function(event)
                    local filetype = vim.bo[event.buf].filetype
                    if filetype == "" then
                        return
                    end

                    local language = vim.treesitter.language.get_lang(filetype) or filetype
                    if not pcall(vim.treesitter.start, event.buf, language) then
                        return
                    end

                    local ok, query = pcall(vim.treesitter.query.get, language, "indents")
                    if ok and query then
                        vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                    end
                end,
            })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        lazy = false,
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",
        lazy = false,
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            require("nvim-treesitter-textobjects").setup({
                select = {
                    lookahead = true,
                    selection_modes = {
                        ["@function.outer"] = "V",
                    },
                },
                move = {
                    set_jumps = true,
                },
            })

            -- mini.ai is configured after lazy.nvim, so extend its runtime config
            -- once startup has finished. Keeping a single a/i dispatcher avoids
            -- longer Treesitter mappings shadowing mini.ai's built-in objects.
            vim.schedule(function()
                local ai = require("mini.ai")
                local treesitter = ai.gen_spec.treesitter

                MiniAi.config.custom_textobjects = vim.tbl_extend(
                    "force",
                    MiniAi.config.custom_textobjects,
                    {
                        c = treesitter({ a = "@class.outer", i = "@class.inner" }),
                        d = { "%f[%d]%d+" },
                        e = {
                            {
                                "%u[%l%d]+%f[^%l%d]",
                                "%f[%S][%l%d]+%f[^%l%d]",
                                "%f[%P][%l%d]+%f[^%l%d]",
                                "^[%l%d]+%f[^%l%d]",
                            },
                            "^().*()$",
                        },
                        f = treesitter({ a = "@function.outer", i = "@function.inner" }),
                        g = function()
                            local last_line = vim.fn.line("$")
                            return {
                                from = { line = 1, col = 1 },
                                to = { line = last_line, col = math.max(vim.fn.col({ last_line, "$" }) - 1, 1) },
                            }
                        end,
                        o = treesitter({
                            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
                            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
                        }),
                        u = ai.gen_spec.function_call(),
                        U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }),
                    }
                )

                -- local.scope belongs to the `locals` query group rather than
                -- `textobjects`, so it cannot be expressed through mini.ai's
                -- Treesitter generator.
                vim.keymap.set({ "x", "o" }, "as", function()
                    require("nvim-treesitter-textobjects.select").select_textobject("@local.scope", "locals")
                end, { desc = "Around local scope" })

                require("which-key").add({
                    { "ac", desc = "Around class", mode = { "x", "o" } },
                    { "ic", desc = "Inside class", mode = { "x", "o" } },
                    { "af", desc = "Around function", mode = { "x", "o" } },
                    { "if", desc = "Inside function", mode = { "x", "o" } },
                    { "ao", desc = "Around block/conditional/loop", mode = { "x", "o" } },
                    { "io", desc = "Inside block/conditional/loop", mode = { "x", "o" } },
                    { "as", desc = "Around local scope", mode = { "x", "o" } },
                })
            end)

            move_textobject("]f", "goto_next_start", "@function.outer", "Next function start")
            move_textobject("[f", "goto_previous_start", "@function.outer", "Previous function start")
            move_textobject("]F", "goto_next_end", "@function.outer", "Next function end")
            move_textobject("[F", "goto_previous_end", "@function.outer", "Previous function end")

            local swap = require("nvim-treesitter-textobjects.swap")
            vim.keymap.set("n", "<leader>ean", function()
                swap.swap_next("@parameter.inner")
            end, { desc = "Swap with next argument" })
            vim.keymap.set("n", "<leader>eap", function()
                swap.swap_previous("@parameter.inner")
            end, { desc = "Swap with previous argument" })
        end,
    },
}
