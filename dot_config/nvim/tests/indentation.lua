-- Run with:
--   XDG_CACHE_HOME=/tmp/nvim-cache XDG_STATE_HOME=/tmp/nvim-state \
--     nvim --headless -n -i NONE -u init.lua -l tests/indentation.lua

local function assert_indents(filetype, content, expected, name)
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)
    vim.api.nvim_set_current_buf(buf)
    vim.cmd("setfiletype " .. filetype)

    for line, indent in ipairs(expected) do
        assert(
            vim.fn.indent(line) == indent,
            ("%s, line %d: expected %d spaces, got %d"):format(
                name,
                line,
                indent,
                vim.fn.indent(line)
            )
        )
    end

    vim.api.nvim_buf_delete(buf, { force = true })
end

assert_indents(
    "swift",
    {
        "struct Example {",
        "    func run() {",
        "        work()",
        "    }",
        "}",
    },
    { 0, 4, 8, 4, 0 },
    "Swift basic blocks"
)

assert_indents(
    "swift",
    {
        "struct Example {",
        "    func run(value: Bool) {",
        "        if value {",
        "            work()",
        "        }",
        "    }",
        "}",
    },
    { 0, 4, 8, 12, 8, 4, 0 },
    "Swift if statement"
)

assert_indents(
    "swift",
    {
        "struct Example {",
        "    func run(value: Bool) {",
        "        switch value {",
        "        case true:",
        "            work()",
        "        default:",
        "            return",
        "        }",
        "    }",
        "}",
    },
    { 0, 4, 8, 8, 12, 8, 12, 8, 4, 0 },
    "Swift switch statement"
)

assert_indents(
    "swift",
    {
        "struct Example {",
        "    func run() {",
        "        let value = { () -> Int in",
        "            return 1",
        "        }()",
        "    }",
        "}",
    },
    { 0, 4, 8, 12, 8, 4, 0 },
    "Swift closure"
)

print("indentation: ok")
