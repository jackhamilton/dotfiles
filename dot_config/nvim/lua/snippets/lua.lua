local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local extras = require("luasnip.extras")
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local conds = require("luasnip.extras.expand_conditions")
local postfix = require("luasnip.extras.postfix").postfix
local types = require("luasnip.util.types")
local parse = require("luasnip.util.parser").parse_snippet
local ms = ls.multi_snippet
local k = require("luasnip.nodes.key_indexer").new_key
local r = require("luasnip.extras").rep

return {
    -- Snippet
    s({trig="snippet", dscr="LuaSnip snippet"},
        {
            t("-- "),
            i(1, "Name"),
            t({"",""}),
            t("s({trig=\""),
            i(2, "Trigger"),
            t("\", dscr=\""),
            d(3, function(args)
                return sn(nil, {
                    i(1, args[1])
                })
            end, { 1 }),
            t({"\"},", ""}),
            t({"\tfmt([[", ""}),
            t("\t\t"),
            i(0),
            t({"", "\t]], {", ""}),
            t({"\t\ti(1,\"\"),","\t\ti(0)",""}),
            t({"\t}, {", ""}),
            t({"\t\tdelimiters = \"<>\"", ""}),
            t({"\t})", ""}),
            t({"),"})
        }
    ),
    -- Dynamic Node
    s({trig="dynamic", dscr="LuaSnip dynamic node"},
        fmt([[
            d(<>, function(args)
                return sn(nil, {
                    i(<>, args[1])
                })
            end, { <> }),
        ]], {
            i(1,"Insert at delimiter index"),
            i(2,"Reference node index"),
            d(3, function(args)
                return sn(nil, {
                    i(2, args[1])
                })
            end, { 2 }),
        }, {
            delimiters = "<>"
        })
    ),
    -- nvim plugin
    -- s({trig="lazyplugin", dscr="nvim plugin"},
    --     fmt([[
    --         return {
    --             {
    --                 "<>/<>.nvim",
    --                 keys = {
    --                     { "<leader><>", function() <> end, desc = "<>"},
    --                 },
    --             }
    --         }
    --     ]], {
    --         i(1,"author"),
    --         i(2,"name"),
    --         i(3,"keys"),
    --         i(4,"function"),
    --         i(5,"description"),
    --     }, {
    --         delimiters = "<>"
    --     })
    -- ),
}
