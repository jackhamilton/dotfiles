local ls = require("luasnip")
local i = ls.insert_node
local t = ls.text_node

return {
    ls.snippet("uiview", {
        t({
            "//",
            "// Created 2026 by Jack Hamilton",
            "//",
        }),
        t({ "", "@RequiredCoderInit" }),
        t("class "),
        i(1, "Name"),
        t(": UIView {"),
        t({
            "",
            "   init() {",
            "       super.init(frame: .zero)",
            "",
            "       installSubviews()",
            "   }",
            "",
            "   private func installSubviews() {",
            "",
            "   }",
            "}",
        }),
    }),
}
