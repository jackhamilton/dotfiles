local match_filetype = function(filename)
    -- attempt with buffer content and filename
    local filetype = vim.filetype.match({ buf = 0, filename = filename })

    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local remove_indices = {}
    for index, line in ipairs(lines) do
        if string.match(line, "\"{{\"") then
            -- insert index at first positon in list
            table.insert(remove_indices, 1, index)
        end
    end
    for _, index in ipairs(remove_indices) do
        -- remove tmpl lines
        table.remove(lines, index)
    end

    if not filetype then
        -- attempt without tmpl lines
        filetype = vim.filetype.match({ filename = filename, contents = lines })
    end

    if not filetype then
        -- attempt without filename
        filetype = vim.filetype.match({ contents = lines })
    end

    if not filetype then
        --attempt just from name
        filetype = vim.filetype.match({ filename = filename })
    end
    return filetype
end

local detect_tmpl_filetype = function()
    local full_filename = vim.fn.expand("%:t")
    if string.sub(full_filename, -5, -1) == ".tmpl" then
        local filename_without_tmpl = vim.fn.fnamemodify(full_filename, ":t:r")
        -- replace 'dot_' with '.'
        local filename = filename_without_tmpl:gsub("dot_", ".")

        vim.bo.filetype = match_filetype(filename) or ""
    end
end

vim.api.nvim_create_autocmd({
    "BufWinEnter"
}, {
    pattern = "*.tmpl",
    callback = detect_tmpl_filetype,
})
