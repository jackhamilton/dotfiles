local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt

return {
    ls.snippet("swlabel", fmt([[
    private lazy var <> = UILabel.with {
         $0.text = "<>".localized()
         $0.font = .<>
         $0.textColor = .Text.<>
         $0.textAlignment = .<>
     }
     ]], {
        ls.insert_node(1, "Variable Name"),
        ls.insert_node(2, "Text"),
        ls.insert_node(3, "Font"),
        ls.insert_node(4, "Text Color"),
        ls.insert_node(5, "Alignment"),
    }, {
        delimiters = "<>",
    })),
}
