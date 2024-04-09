-- nvim/lua/user/cmp.lua
local status, treesitter = pcall(require, "nvim-treesitter.configs")
if not status then
    return
end

treesitter.setup({
    highlight = {
        enable = true,
    },
    indent = {
        enable = true,
    },
    ensure_installed = {
        "json",
        "c",
        "cpp",
        "swift",
        "gdscript",
        "lua",
        "vim",
        "rust",
        "markdown",
        "markdown_inline",
        "bash",
    },
    auto_install = true,
})

vim.api.nvim_set_hl(0, "@function.call", { link = "Special" })
