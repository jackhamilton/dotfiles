-- Buffer removing (unshow, delete, wipeout), which saves window layout
-- require("mini.bufremove").setup()

--- Autopairs
require("mini.pairs").setup({
    modes = { insert = true, command = true, terminal = false },
})

--- Surround
require("mini.surround").setup({
    mappings = {
        add = 'Sa',
        delete = 'Sd',
        find = 'Sf',
        find_left = 'SF',
        highlight = 'Sh',
        replace = 'Sr',
        update_n_lines = 'Sn',
    }
})

require("mini.splitjoin").setup()

require("mini.move").setup(
    {
        -- Module mappings. Use `''` (empty string) to disable one.
        mappings = {
            -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
            left = '<M-Left>',
            right = '<M-Right>',
            down = '<M-Down>',
            up = '<M-Up>',

            -- Move current line in Normal mode
            line_left = '',
            line_right = '',
            line_down = '',
            line_up = '',
        },

        -- Options which control moving behavior
        options = {
            -- Automatically reindent selection during linewise vertical move
            reindent_linewise = true,
        },
    }
)

require("mini.ai").setup({
    search_method = "cover_or_nearest"
})

-- More consistent behavior of <CR>
-- local keys = {
-- 	["cr"] = vim.api.nvim_replace_termcodes("<CR>", true, true, true),
-- 	["ctrl-y"] = vim.api.nvim_replace_termcodes("<C-y>", true, true, true),
-- 	["ctrl-y_cr"] = vim.api.nvim_replace_termcodes("<C-y><CR>", true, true, true),
-- }
-- _G.cr_action = function()
-- 	if vim.fn.pumvisible() ~= 0 then
-- 		-- If popup is visible, confirm selected item or add new line otherwise
-- 		local item_selected = vim.fn.complete_info()["selected"] ~= -1
-- 		return item_selected and keys["ctrl-y"] or keys["ctrl-y_cr"]
-- 	else
-- 		return require("mini.pairs").cr()
-- 	end
-- end
--
-- vim.keymap.set("i", "<CR>", "v:lua._G.cr_action()", { expr = true })

--- Visualize and operate on indent scope
-- require("mini.indentscope").setup({
--   symbol = "│",
-- })
