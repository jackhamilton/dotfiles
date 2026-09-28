local refresh = require("utils.origami_outline.refresh")
local state = require("utils.origami_outline.state")

local M = {}

local function refreshWindows(buf)
    for _, win in ipairs(vim.fn.win_findbuf(buf)) do
        vim.schedule(function()
            refresh.refresh(buf, win)
        end)
    end
end

function M.setup()
    state.reset()
    local group = vim.api.nvim_create_augroup("origami_source_outline", { clear = true })
    vim.api.nvim_create_autocmd({
        "FileType",
        "BufWinEnter",
        "WinEnter",
        "TextChanged",
        "TextChangedI",
        "InsertLeave",
        "LspAttach",
    }, {
        group = group,
        callback = function(event) refreshWindows(event.buf) end,
    })
    vim.api.nvim_create_autocmd("WinClosed", {
        group = group,
        callback = function(event) state.clear(tonumber(event.match)) end,
    })

    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        vim.schedule(function() refresh.refresh(buf, win) end)
    end
end

return M
