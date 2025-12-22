vim.cmd('runtime vim/vs-setup.vim')
vim.g.mapleader = " "
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)
local pluginDirectories = {
    { import = "plugins.lazy" },
}
if vim.fn.OSX() == 1 then
    table.insert(pluginDirectories, { import = "plugins.osx" })
end
require("lazy").setup({
    spec = pluginDirectories,
    checker = {
        enabled = true,
        frequency = 14400,
    },
})


-- Load configuration core
local loaded_core, core_err = xpcall(require, debug.traceback, "core")
if not loaded_core then
    vim.notify_once(
        string.format("There was an error requiring 'core'. Traceback:\n%s", core_err),
        vim.log.levels.ERROR
    )
end

local loaded_plugin_config, config_err = xpcall(require, debug.traceback, "plugins.config")
if not loaded_plugin_config then
    vim.notify_once(
        string.format("There was an error requiring 'plugin_config'. Traceback:\n%s", config_err),
        vim.log.levels.ERROR
    )
end

local Snacks = require("snacks")
_G.dd = function(...)
    Snacks.debug.inspect(...)
end
_G.bt = function()
    Snacks.debug.backtrace()
end
vim.print = _G.dd
