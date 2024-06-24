--- Buffer removing (unshow, delete, wipeout), which saves window layout
require("mini.bufremove").setup()

--- Autopairs
require("mini.pairs").setup({
    modes = { insert = true, command = true, terminal = false },
})

--- Surround
require("mini.surround").setup()

require("mini.ai").setup()
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
require("which-key").register({
    mode = { "o", "x" },
    i = i,
    a = a,
})

require("mini.files").setup()
vim.keymap.set("n", "<leader>fs", function() MiniFiles.open() end, { silent = true, desc = "Open filesystem", })

--- Completion
require("mini.completion").setup({
    window = {
        info = { border = "single" },
        signature = { border = "single" },
    },
})
vim.keymap.set("n", "<leader>tc", function()
    local is_completion_disabled = vim.b.minicompletion_disable
    if not is_completion_disabled then
        vim.b.minicompletion_disable = true
        vim.notify("[nvim] Completion has been temporarily disabled in this buffer")
    else
        vim.b.minicompletion_disable = false
        vim.notify("[nvim] Completion has been enabled again in this buffer")
    end
end, {
    silent = true,
    desc = "Toggle completion",
})

-- More consistent behavior of <CR>
local keys = {
    ["cr"] = vim.api.nvim_replace_termcodes("<CR>", true, true, true),
    ["ctrl-y"] = vim.api.nvim_replace_termcodes("<C-y>", true, true, true),
    ["ctrl-y_cr"] = vim.api.nvim_replace_termcodes("<C-y><CR>", true, true, true),
}
_G.cr_action = function()
    if vim.fn.pumvisible() ~= 0 then
        -- If popup is visible, confirm selected item or add new line otherwise
        local item_selected = vim.fn.complete_info()["selected"] ~= -1
        return item_selected and keys["ctrl-y"] or keys["ctrl-y_cr"]
    else
        return require("mini.pairs").cr()
    end
end

vim.keymap.set("i", "<CR>", "v:lua._G.cr_action()", { expr = true })

--- Visualize and operate on indent scope
-- require("mini.indentscope").setup({
--   symbol = "│",
-- })
