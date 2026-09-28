local M = {}

---@param win number
---@param line number
function M.openTypeFold(win, line)
    vim.api.nvim_win_call(win, function()
        local previousStart
        for _ = 1, 20 do
            local foldstart = vim.fn.foldclosed(line)
            if foldstart < 0 then return end
            if foldstart == previousStart then return end

            previousStart = foldstart
            pcall(vim.cmd, ("silent! %dfoldopen"):format(line))
            if foldstart == line then return end
        end
    end)
end

---@param win number
---@param line number
function M.openContainingFolds(win, line)
    vim.api.nvim_win_call(win, function()
        for _ = 1, 20 do
            if vim.fn.foldclosed(line) < 0 then return end
            pcall(vim.cmd, ("silent! %dfoldopen"):format(line))
        end
    end)
end

return M
