local M = {}

---@param buf number
---@param language string
function M.exposeFiletype(buf, language)
    if vim.bo[buf].filetype ~= "snacks_picker_preview" then return end
    if not language:match("^[%w_]+$") then return end

    vim.api.nvim_buf_call(buf, function()
        vim.cmd(("noautocmd set filetype=%s"):format(language))
    end)

    local buftype = vim.bo[buf].buftype
    vim.bo[buf].buftype = "nofile"
    pcall(vim.api.nvim_exec_autocmds, "FileType", {
        buffer = buf,
        modeline = false,
    })
    if vim.api.nvim_buf_is_valid(buf) then vim.bo[buf].buftype = buftype end
end

return M
