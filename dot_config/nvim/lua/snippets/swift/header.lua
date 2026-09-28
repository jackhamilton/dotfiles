local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt

local f = ls.function_node

return {
    ls.snippet("header", fmt([[
// <>.swift
// SuperSecure
//
// Created by Jack Hamilton on <>.
//
]], {
        f(function()
            return vim.fn.expand("%:t:r")
        end),
        f(function()
            return os.date("%m/%d/%y")
        end),
    }, {
        delimiters = "<>",
    })),
}
