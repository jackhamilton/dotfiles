local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt

return {
    ls.snippet("swconstraint", fmt([[
        <>
            .addedToSuperview(self)
            .disableAutoresizingMask()
            .anchorToSuperviewLeading()
            .anchorToSuperviewTop()
            .anchorToSuperviewBottom()
            .anchorToSuperviewTrailing()
    ]], {
        ls.insert_node(1, "Name"),
    }, {
        delimiters = "<>",
    })),
}
