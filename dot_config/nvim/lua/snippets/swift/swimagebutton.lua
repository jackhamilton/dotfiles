local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt

return {
    ls.snippet("swimagebutton", fmt([[
    private let <> = UIButton.with {
        $0.setImageType(.<>, for: .normal)
        $0.tintColor = .swatch(.pureWhite)
    }
    ]], {
        ls.insert_node(1, "Variable name"),
        ls.insert_node(2, "ImageType"),
    }, {
        delimiters = "<>",
    })),
}
