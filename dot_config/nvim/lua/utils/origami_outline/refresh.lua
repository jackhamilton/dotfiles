local folds = require("utils.origami_outline.folds")
local foldexpr = require("utils.origami_outline.foldexpr")
local preview = require("utils.origami_outline.preview")
local state = require("utils.origami_outline.state")
local treesitter = require("utils.origami_outline.treesitter")

local M = {}

---@param buf number
---@param win number
---@param opts? { preview?: boolean, force?: boolean, noRetry?: boolean, diffview?: boolean }
function M.refresh(buf, win, opts)
    opts = opts or {}
    if not vim.api.nvim_buf_is_valid(buf) or not vim.api.nvim_win_is_valid(win) then return end
    if not vim.api.nvim_buf_is_loaded(buf) or vim.api.nvim_win_get_buf(win) ~= buf then return end
    if vim.api.nvim_buf_get_name(buf):match("^diffview://") and not opts.diffview then return end

    local parser, language = treesitter.parserForBuffer(buf)
    if not parser or not language or not treesitter.hasFolds(language) then return end

    local isPreview = opts.preview or vim.w[win].snacks_picker_preview == true
    if isPreview then preview.exposeFiletype(buf, language) end

    vim.api.nvim_win_call(win, function()
        vim.wo.foldenable = true
        vim.wo.foldmethod = "expr"
        vim.wo.foldexpr = foldexpr.expression
        vim.wo.foldtext = ""
    end)
    vim.b[buf].origami_folding_provider = "treesitter"

    local generation = isPreview and vim.b[buf].changedtick or nil
    local previous = state.get(win)
    local rebuild = opts.force
        or not previous
        or previous.buf ~= buf
        or previous.language ~= language
        or previous.generation ~= generation
    local cursor = vim.api.nvim_win_get_cursor(win)

    if rebuild then
        vim.api.nvim_win_call(win, function()
            vim.wo.foldmethod = "manual"
            vim.wo.foldmethod = "expr"
            vim.wo.foldexpr = foldexpr.expression
            vim.wo.foldlevel = 0
            pcall(vim.treesitter.foldexpr, 1)
            pcall(vim.cmd, "silent! %foldclose!")
        end)
        for _, line in ipairs(treesitter.typeLines(parser, language, buf)) do
            folds.openTypeFold(win, line)
        end
        state.set(win, { buf = buf, language = language, generation = generation })
    end

    folds.openContainingFolds(win, cursor[1])

    if isPreview and vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_buf(win) == buf then
        pcall(vim.api.nvim_win_set_cursor, win, cursor)
    end

    if rebuild and not opts.noRetry then
        local expectedChangedtick = vim.b[buf].changedtick
        vim.defer_fn(function()
            if not vim.api.nvim_buf_is_valid(buf) or not vim.api.nvim_win_is_valid(win) then return end
            if vim.api.nvim_win_get_buf(win) ~= buf or vim.b[buf].changedtick ~= expectedChangedtick then return end
            M.refresh(buf, win, { preview = isPreview, force = true, noRetry = true })
        end, 20)
    end
end

function M.openContainingFolds(win, line)
    return folds.openContainingFolds(win, line)
end

---@param picker snacks.Picker
function M.refreshPicker(picker)
    vim.schedule(function()
        if picker.closed or not picker.preview then return end
        local pickerPreview = picker.preview
        if not pickerPreview.win or not pickerPreview.win:valid() then return end
        M.refresh(pickerPreview.win.buf, pickerPreview.win.win, { preview = true })
    end)
end

return M
