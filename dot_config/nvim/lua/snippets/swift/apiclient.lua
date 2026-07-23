local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node
local d = ls.dynamic_node
local sn = ls.snippet_node

return {
    ls.snippet({ trig = "apiclient", dscr = "API Client" }, fmt([[
        import SFTypes
        import Foundation

        final class &+APIClient: Sendable {
            private let transport: APITransport

            init(transport: APITransport) {
                self.transport = transport
            }

            func get&+() async throws -> &+ {
                try await transport.sendDecoding(
                    &+Endpoint.&+(),
                    responseType: &+.self
                )
            }
        }
        ]], {
        i(1, "Name"),
        i(2, "Endpoint"),
        i(3, "Decoding Type"),
        d(4, function(args)
            return sn(nil, {
                i(1, args[1])
            })
        end, { 1 }),
        d(5, function(args)
            return sn(nil, {
                i(2, args[1])
            })
        end, { 2 }),
        d(6, function(args)
            return sn(nil, {
                i(3, args[1])
            })
        end, { 3 }),
    }, {
        delimiters = "&+",
    })),
}
