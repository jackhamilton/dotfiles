local ls = require("luasnip")
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt
local d = ls.dynamic_node
local sn = ls.snippet_node

return {
    ls.snippet({ trig = "macrofixit", dscr = "Macro Fixit" },
        fmt([[
struct @#Diagnostic: SwiftDiagnostics.DiagnosticMessage {
    var message: String {
        "ExampleStruct requires a nested struct named '@#' on the applied type"
    }

    var severity: SwiftDiagnostics.DiagnosticSeverity {
        .error
    }

    var diagnosticID: SwiftDiagnostics.MessageID {
        .init(domain: "SFMacros", id: "MissingExampleStruct")
    }

    var fixItID: SwiftDiagnostics.MessageID {
        diagnosticID
    }
}

struct @#FixIt: FixItMessage {
    var message: String {
        "Add 'Example' member struct"
    }

    var diagnosticID: SwiftDiagnostics.MessageID {
        .init(domain: "SFMacros", id: "MissingExampleStruct.FixIt")
    }

    var fixItID: SwiftDiagnostics.MessageID {
        diagnosticID
    }
}

// // check that it has a required member
// for member in structDecl.memberBlock.members {
//     if let nested = member.decl.as(SwiftSyntax.StructDeclSyntax.self),
//        nested.name.text == "AsyncData" {
//         let fixedMemberBlock = try SwiftSyntax.MemberBlockSyntax("""
//         {
//             \(raw: structDecl.memberBlock.members.compactMap { $0.description }.joined(separator: "\n") ?? "")
//             \(raw: "let requiredMember: AnyObject"))
//         }
//         """)
//
//         context.diagnose(
//             SwiftDiagnostics.Diagnostic(
//                 node: SwiftSyntax.Syntax(structDecl),
//                 message: @#Diagnostic(),
//                 fixIt: FixIt(
//                     message: @#FixIt(),
//                     changes: [
//                         .replace(
//                             oldNode: Syntax(structDecl.memberBlock),
//                             newNode: Syntax(fixedMemberBlock)
//                         ),
//                     ]
//                 )
//             )
//         )
//         break
//     }
// }
        ]], {
        i(1, "Name"),
        d(2, function(args)
            return sn(nil, {
                i(1, args[1]),
            })
        end, { 1 }),
        d(3, function(args)
            return sn(nil, {
                i(1, args[1])
            })
        end, { 1 }),
        d(4, function(args)
            return sn(nil, {
                i(1, args[1])
            })
        end, { 1 }),
        d(5, function(args)
            return sn(nil, {
                i(1, args[1])
            })
        end, { 1 }),
    }, {
        delimiters = "@#",
    })),
}
