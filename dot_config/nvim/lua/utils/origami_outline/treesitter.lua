local M = {}

local typeQuerySources = {
    swift = "(class_declaration) @type",
    rust = "[(struct_item) (impl_item)] @type",
    c = "(struct_specifier) @type",
    cpp = "[(class_specifier) (struct_specifier)] @type",
    javascript = "(class_declaration) @type",
    typescript = "(class_declaration) @type",
    tsx = "(class_declaration) @type",
}

local typeQueries = {}

---@param buf number
---@return vim.treesitter.LanguageTree?, string?
function M.parserForBuffer(buf)
    if not vim.api.nvim_buf_is_valid(buf) or not vim.api.nvim_buf_is_loaded(buf) then return end

    local highlighter = vim.treesitter.highlighter.active[buf]
    local parser = highlighter and highlighter.tree or nil
    if not parser then
        local filetype = vim.bo[buf].filetype
        if filetype == "" or filetype == "snacks_picker_preview" then return end
        local language = vim.treesitter.language.get_lang(filetype) or filetype
        local ok
        ok, parser = pcall(vim.treesitter.get_parser, buf, language)
        if not ok or not parser then return end
    end

    local ok, language = pcall(parser.lang, parser)
    if not ok then return end
    return parser, language
end

---@param language string
---@return vim.treesitter.Query?
local function typeQuery(language)
    local cached = typeQueries[language]
    if cached ~= nil then return cached or nil end

    local source = typeQuerySources[language]
    if not source then
        typeQueries[language] = false
        return nil
    end

    local ok, query = pcall(vim.treesitter.query.parse, language, source)
    typeQueries[language] = ok and query or false
    return ok and query or nil
end

---@param parser vim.treesitter.LanguageTree
---@param language string
---@param buf number
---@return number[]
function M.typeLines(parser, language, buf)
    local query = typeQuery(language)
    if not query then return {} end

    local trees = parser:parse()
    local tree = trees and trees[1]
    if not tree then return {} end

    local lines = {}
    local seen = {}
    for _, node in query:iter_captures(tree:root(), buf) do
        local startRow = node:range()
        local line = startRow + 1
        if not seen[line] then
            seen[line] = true
            lines[#lines + 1] = line
        end
    end
    return lines
end

function M.hasFolds(language)
    local ok, folds = pcall(vim.treesitter.query.get, language, "folds")
    return ok and folds ~= nil
end

return M
