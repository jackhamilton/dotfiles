local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt

return {
    ls.snippet("attributedstring", fmt([[
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.<>
        ]
        let attributedText = NSAttributedString(string: "<>".localized())
    ]], {
        ls.insert_node(1, "Font"),
        ls.insert_node(2, "Text"),
    }, {
        delimiters = "<>",
    })),
}
