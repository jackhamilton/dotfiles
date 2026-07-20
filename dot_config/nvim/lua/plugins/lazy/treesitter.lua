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
        keys = {
            {
                "]f",
                function()
                    require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
                end,
                mode = { "n", "x", "o" },
                desc = "Next function start",
            },
            {
                "[f",
                function()
                    require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")
                end,
                mode = { "n", "x", "o" },
                desc = "Previous function start",
            },
            {
                "]F",
                function()
                    require("nvim-treesitter-textobjects.move").goto_next_end("@function.outer", "textobjects")
                end,
                mode = { "n", "x", "o" },
                desc = "Next function end",
            },
            {
                "[F",
                function()
                    require("nvim-treesitter-textobjects.move").goto_previous_end("@function.outer", "textobjects")
                end,
                mode = { "n", "x", "o" },
                desc = "Previous function end",
            },
            {
                "as",
                function()
                    require("nvim-treesitter-textobjects.select").select_textobject("@local.scope", "locals")
                end,
                mode = { "x", "o" },
                desc = "Around local scope",
            },
            {
                "<leader>ean",
                function()
                    require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner")
                end,
                desc = "Swap with next argument",
            },
            {
                "<leader>eap",
                function()
                    require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.inner")
                end,
                desc = "Swap with previous argument",
            },
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

                -- Syntax nodes do not include the indentation before their first
                -- token. A characterwise operator over a multiline inner node can
                -- therefore join that indentation to the closing delimiter (for
                -- example, `dio` would over-indent a Swift closing brace). Treat
                -- captures which occupy otherwise blank lines as linewise objects.
                local function inner_lines(captures)
                    local spec = treesitter(captures)

                    return function(ai_type, id, opts)
                        local regions = spec(ai_type, id, opts)
                        if ai_type ~= "i" then
                            return regions
                        end

                        for _, region in ipairs(regions) do
                            local first = vim.fn.getline(region.from.line)
                            local last = vim.fn.getline(region.to.line)
                            local before = first:sub(1, region.from.col - 1)
                            local after = last:sub(region.to.col + 1)

                            -- Some parsers include the newline and indentation
                            -- immediately before the closing delimiter. Keep that
                            -- delimiter line out of a linewise inner selection.
                            local selected_on_last = last:sub(1, region.to.col)
                            if
                                region.to.line > region.from.line
                                and selected_on_last:match("^%s*$")
                                and not after:match("^%s*$")
                            then
                                region.to.line = region.to.line - 1
                                region.to.col = math.max(#vim.fn.getline(region.to.line), 1)
                                after = ""
                            end

                            if before:match("^%s*$") and after:match("^%s*$") then
                                region.vis_mode = "V"
                            end
                        end

                        return regions
                    end
                end

                MiniAi.config.custom_textobjects = vim.tbl_extend(
                    "force",
                    MiniAi.config.custom_textobjects,
                    {
                        c = inner_lines({ a = "@class.outer", i = "@class.inner" }),
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
                        f = inner_lines({ a = "@function.outer", i = "@function.inner" }),
                        g = function()
                            local last_line = vim.fn.line("$")
                            return {
                                from = { line = 1, col = 1 },
                                to = { line = last_line, col = math.max(vim.fn.col({ last_line, "$" }) - 1, 1) },
                            }
                        end,
                        o = inner_lines({
                            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
                            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
                        }),
                        u = ai.gen_spec.function_call(),
                        U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }),
                    }
                )

                require("which-key").add({
                    { "ac", desc = "Around class", mode = { "x", "o" } },
                    { "ic", desc = "Inside class", mode = { "x", "o" } },
                    { "af", desc = "Around function", mode = { "x", "o" } },
                    { "if", desc = "Inside function", mode = { "x", "o" } },
                    { "ao", desc = "Around block/conditional/loop", mode = { "x", "o" } },
                    { "io", desc = "Inside block/conditional/loop", mode = { "x", "o" } },
                })
            end)
        end,
    },
}
