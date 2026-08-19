-- Run with:
-- XDG_CACHE_HOME=/tmp/nvim-cache XDG_STATE_HOME=/tmp/nvim-state \
--   nvim --headless "+luafile tests/origami_outline.lua" "+qa!"

require("lazy").load({ plugins = { "nvim-origami" } })

local outline = require("utils.origami_outline")
local win = vim.api.nvim_get_current_win()

local function lines(buf, content)
    vim.bo[buf].modifiable = true
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)
    vim.bo[buf].modifiable = false
end

local function sourceBuffer(language, content)
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_win_set_buf(win, buf)
    lines(buf, content)
    vim.bo[buf].filetype = language
    assert(pcall(vim.treesitter.start, buf, language), language .. " parser is unavailable")
    return buf
end

local swift = sourceBuffer("swift", {
    "class CursorTest {",
    "    func staysClosed() {",
    "        print(1)",
    "    }",
    "    func target() {",
    "        if true {",
    "            print(2)",
    "        }",
    "    }",
    "}",
})
vim.api.nvim_win_set_cursor(win, { 7, 0 })
outline.refresh(swift, win)
assert(vim.fn.foldclosed(2) == 2, "unrelated Swift method should stay folded")
assert(vim.fn.foldclosed(7) == -1, "Swift cursor target should be visible")

local rust = sourceBuffer("rust", {
    "struct Example {",
    "    value: usize,",
    "}",
    "",
    "fn helper() {",
    "    if true {",
    "        println!(\"hello\");",
    "    }",
    "}",
})
vim.api.nvim_win_set_cursor(win, { 1, 0 })
outline.refresh(rust, win)
assert(vim.fn.foldclosed(1) == -1, "Rust struct contents should be visible")
assert(vim.fn.foldclosed(5) == 5, "free Rust function should stay folded")

vim.wo[win].foldmethod = "manual"
local preview = sourceBuffer("swift", {
    "class First {",
    "    func hidden() {",
    "        if true {",
    "            print(1)",
    "        }",
    "    }",
    "}",
})
vim.bo[preview].filetype = "snacks_picker_preview"
vim.w[win].snacks_picker_preview = true
vim.api.nvim_win_set_cursor(win, { 1, 0 })
outline.refresh(preview, win, { preview = true })
vim.wait(50)
assert(vim.fn.foldclosed(2) == 2, "preview method should initially stay folded")

vim.api.nvim_win_set_cursor(win, { 4, 0 })
outline.refresh(preview, win, { preview = true })
assert(vim.fn.foldclosed(4) == -1, "preview target should be visible")

vim.wo[win].foldmethod = "manual"
lines(preview, {
    "",
    "",
    "class Second {",
    "    func shouldClose() {",
    "        if true {",
    "            print(2)",
    "        }",
    "    }",
    "}",
})
vim.api.nvim_win_set_cursor(win, { 3, 0 })
outline.refresh(preview, win, { preview = true })
vim.wait(50)
assert(vim.fn.foldclosed(3) == -1, "reused preview type should be open")
assert(vim.fn.foldclosed(4) == 4, "reused preview method should be folded")

local deleted = vim.api.nvim_create_buf(false, true)
vim.api.nvim_buf_delete(deleted, { force = true })
assert(pcall(outline.refresh, deleted, win), "deleted buffers should be ignored")

local unsupported = vim.api.nvim_create_buf(false, true)
vim.api.nvim_win_set_buf(win, unsupported)
vim.bo[unsupported].filetype = "origami_missing_parser"
assert(
    pcall(outline.refresh, unsupported, win),
    "buffers without an installed Tree-sitter parser should be ignored"
)

print("origami outline: ok")
