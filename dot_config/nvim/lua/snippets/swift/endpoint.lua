local ls = require("luasnip")
local i = ls.insert_node
local d = ls.dynamic_node
local sn = ls.snippet_node
local fmt = require("luasnip.extras.fmt").fmt

return {
    ls.snippet({ trig = "endpoint", dscr = "API Endpoint" }, fmt([[
        import Foundation

        enum &+Endpoint {
            case &+

            var method: APIMethod {
                switch self {
                case .&+:
                    // todo: method
                }
            }

            var path: String {
                switch self {
                case .&+:
                    // todo: path
                }
            }

            var headers: [String: String] {
                switch self {
                case .&+:
                    return [:]
                }
            }

            func body() throws -> Data? {
                // let encoder = JSONEncoder()
                // encoder.keyEncodingStrategy = .convertToSnakeCase
                // encoder.outputFormatting = [.sortedKeys]

                switch self {
                case .&+:
                    return nil
                // case .example(let request):
                //     return try encoder.encode(request)
                }
            }
        }
        ]], {
        i(1, "Name"),
        i(2, "Endpoint"),
        d(3, function(args)
            return sn(nil, {
                i(2, args[1])
            })
        end, { 2 }),
        d(4, function(args)
            return sn(nil, {
                i(2, args[1])
            })
        end, { 2 }),
        d(5, function(args)
            return sn(nil, {
                i(2, args[1])
            })
        end, { 2 }),
        d(6, function(args)
            return sn(nil, {
                i(2, args[1])
            })
        end, { 2 }),
    }, {
        delimiters = "&+",
    })),
}
