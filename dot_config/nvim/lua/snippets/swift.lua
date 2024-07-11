local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
-- local r = require("luasnip.extras").rep

return {
    s("grheader", {
        t({
            "//",
            "//",
            "// Copyright 2024 by Grindr LLC,",
            "// All rights reserved.",
            "//",
            "// This software is confidential and proprietary information of",
            "// Grindr LLC (\"Confidential Information\").",
            "// You shall not disclose such Confidential Information and shall use",
            "// it only in accordance with the terms of the license agreement",
            "// you entered into with Grindr LLC.",
            "//",
        })
    }),
    -- Grindr simple view snippet
    s("grview", {
        t({
            "//",
            "//",
            "// Copyright 2024 by Grindr LLC,",
            "// All rights reserved.",
            "//",
            "// This software is confidential and proprietary information of",
            "// Grindr LLC (\"Confidential Information\").",
            "// You shall not disclose such Confidential Information and shall use",
            "// it only in accordance with the terms of the license agreement",
            "// you entered into with Grindr LLC.",
            "//",
            "import Foundation",
            "import GrindrDesignKit",
            "import RxCocoa",
            "import RxSwift",
            ""
        }),
        t("class "), i(1, "Name"), t(": UIView {"),
        t({
            "   init() {",
            "       super.init(frame: .zero)",
            "",
            "       installSubviews()",
            "   }",
            "",
            "   @available(*, unavailable)",
            "   required init?(coder: NSCoder) {",
            "       fatalError(\"init(coder:) has not been implemented\")",
            "   }",
            "",
            "   private func installSubviews() {",
            "",
            "   }",
            "}",
        })
    })
}
