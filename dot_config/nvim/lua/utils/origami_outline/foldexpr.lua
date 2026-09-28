local M = {}

local function native(line)
    return vim.treesitter.foldexpr(line)
end

local function level(value)
    return tonumber(value:match("(%d+)$"))
end

function M.foldexpr()
    local line = vim.v.lnum
    if vim.bo.filetype ~= "swift" then
        return native(line)
    end

    local text = vim.fn.getline(line)
    local nextText = vim.fn.getline(line + 1)
    local isDotLine = text:match("^%s*%.") ~= nil
    local nextIsDotLine = nextText:match("^%s*%.") ~= nil

    if not isDotLine and nextIsDotLine then
        -- Start a single fold for a multiline SwiftUI modifier chain.
        local parent = level(native(line - 1))
        if parent then return ">" .. (parent + 1) end
    elseif isDotLine then
        local start = line
        while start > 1 and vim.fn.getline(start - 1):match("^%s*%.") do
            start = start - 1
        end

        if start > 1 and vim.fn.getline(start - 1):match("^%s*%.") == nil then
            local parent = level(native(start - 2))
            if parent then return tostring(parent + 1) end
        end
    end

    return native(line)
end

M.expression = "v:lua.require'utils.origami_outline.foldexpr'.foldexpr()"

return M
