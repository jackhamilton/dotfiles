local ls = require("luasnip")
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt
local d = ls.dynamic_node
local sn = ls.snippet_node

return {
    ls.snippet({ trig = "membermacro", dscr = "Member Macro" },
        fmt([[
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacros

public enum @#Macro: MemberMacro {
    public static func expansion(
        of _: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        conformingTo _: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        // check that it's a struct
        guard let structDecl = declaration.as(SwiftSyntax.StructDeclSyntax.self) else {
            context.diagnose(
                SwiftDiagnostics.Diagnostic(
                    node: SwiftSyntax.Syntax(declaration),
                    message: NotAStructDiagnostic()
                )
            )
            return []
        }

        // Add some additional members
        return [
            DeclSyntax(
                """
                public let example: String
                """
            ),
        ]
    }
}
        ]], {
        i(1, "Name"),
    }, {
        delimiters = "@#",
    })),
}
