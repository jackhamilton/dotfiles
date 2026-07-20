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
    }
})

local wk = require("which-key")

wk.add({
  { "S", group = "Surround", mode = { "n", "x", "o" } },
})

require("mini.splitjoin").setup()

-- require("mini.bracketed").setup()

require("mini.move").setup(
    {
        -- Module mappings. Use `''` (empty string) to disable one.
        mappings = {
            -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
            left = '<M-m>',
            right = '<M-i>',
            down = '<M-n>',
            up = '<M-e>',

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
    search_method = "cover_or_nearest",
    custom_textobjects = {
        [","] = require("core.textobjects").comma_list_item(),
    },
})
-- from lazyvim
---@type table<string, string|table>
local i = {
[" "] = "Whitespace",
['"'] = 'Balanced "',
["'"] = "Balanced '",
["`"] = "Balanced `",
["("] = "Balanced (",
[")"] = "Balanced ) including white-space",
[">"] = "Balanced > including white-space",
["<lt>"] = "Balanced <",
["]"] = "Balanced ] including white-space",
["["] = "Balanced [",
["}"] = "Balanced } including white-space",
["{"] = "Balanced {",
["?"] = "User Prompt",
_ = "Underscore",
a = "Argument",
b = "Balanced ), ], }",
c = "Class",
[","] = "Comma-separated item",
d = "Digit(s)",
e = "Word in CamelCase & snake_case",
f = "Function",
g = "Entire file",
i = "Indent",
o = "Block, conditional, loop",
q = "Quote `, \", '",
t = "Tag",
u = "Use/call function & method",
U = "Use/call without dot in name",
}
local a = vim.deepcopy(i)
for k, v in pairs(a) do
a[k] = v:gsub(" including.*", "")
end

local ic = vim.deepcopy(i)
local ac = vim.deepcopy(a)
for key, name in pairs({ n = "Next", l = "Last" }) do
    i[key] = vim.tbl_extend("force", { name = "Inside " .. name .. " textobject" }, ic)
    a[key] = vim.tbl_extend("force", { name = "Around " .. name .. " textobject" }, ac)
end
local textobject_specs = {}
local textobject_modes = { "o", "x" }

local function add_textobject_specs(prefix, mappings)
    for key, value in pairs(mappings) do
        if key ~= "name" then
            local lhs = prefix .. key
            if type(value) == "string" then
                table.insert(textobject_specs, { lhs, desc = value, mode = textobject_modes })
            else
                table.insert(textobject_specs, { lhs, group = value.name, mode = textobject_modes })
                add_textobject_specs(lhs, value)
            end
        end
    end
end

add_textobject_specs("i", i)
add_textobject_specs("a", a)
wk.add(textobject_specs)

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
