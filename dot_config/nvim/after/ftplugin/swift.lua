local cr = vim.api.nvim_replace_termcodes("<CR>", true, false, true)
vim.keymap.set("i", "<CR>", function()
    local line = vim.api.nvim_get_current_line()
    local row = vim.api.nvim_win_get_cursor(0)[1]
    local col = vim.api.nvim_win_get_cursor(0)[2]
    local pair = line:sub(col, col + 1)
    local pairs_enabled = vim.g.minipairs_disable ~= true and vim.b.minipairs_disable ~= true

    if pairs_enabled and (pair == "{}" or pair == "()" or pair == "[]") then
        local base_indent = line:match("^%s*") or ""
        local indent_unit = vim.bo.expandtab and string.rep(" ", vim.fn.shiftwidth()) or "\t"

        -- Apply the whole expansion at once. Indent functions otherwise see a
        -- temporarily incomplete Swift tree between mini.pairs' two edits,
        -- which can put either the inner line or closing delimiter at column 0.
        pcall(vim.cmd, "undojoin")
        vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col, {
            "",
            base_indent .. indent_unit,
            base_indent,
        })
        vim.api.nvim_win_set_cursor(0, { row + 1, #base_indent + #indent_unit })
        return
    end

    -- Insert before any typeahead already queued after this mapping.
    vim.api.nvim_feedkeys(cr, "ni", false)
end, {
    buffer = true,
    desc = "Newline with Swift pair indentation",
})

vim.b.undo_ftplugin = (vim.b.undo_ftplugin or "")
    .. " | silent! iunmap <buffer> <CR>"
