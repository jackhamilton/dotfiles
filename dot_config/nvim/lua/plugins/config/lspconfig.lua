local lsp = require("lspconfig")

-- cursorhold
vim.opt.updatetime = 250

--- Diagnostics configuration
local severity = vim.diagnostic.severity
vim.diagnostic.config({
    underline = {
        severity = {
            min = severity.WARN,
        },
    },
    signs = {
        severity = {
            min = severity.WARN,
        },
    },
    virtual_text = false,
    update_in_insert = true,
    severity_sort = true,
    float = {
        source = "always",
        border = "rounded",
        show_header = false,
    },
})

--- Improve UI
local sign_define = vim.fn.sign_define
sign_define("DiagnosticSignError", { text = "", texthl = "DiagnosticSignError" })
sign_define("DiagnosticSignWarn", { text = "", texthl = "DiagnosticSignWarn" })
sign_define("DiagnosticSignInfo", { text = "", texthl = "DiagnosticSignInfo" })
sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })

-- vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
--     vim.lsp.handlers.signature_help,
--     { border = "rounded", close_events = { "CursorMoved", "BufHidden", "InsertCharPre" } }
-- )
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
    vim.lsp.handlers.hover,
    { border = "rounded", close_events = { "CursorMoved", "BufHidden" } }
)
local icons = {
    Class = " ",
    Color = " ",
    Constant = " ",
    Constructor = " ",
    Enum = " ",
    EnumMember = " ",
    Event = " ",
    Field = " ",
    File = " ",
    Folder = " ",
    Function = "󰊕 ",
    Interface = " ",
    Keyword = " ",
    Method = "ƒ ",
    Module = "󰏗 ",
    Property = " ",
    Snippet = " ",
    Struct = " ",
    Text = " ",
    Unit = " ",
    Value = " ",
    Variable = " ",
}

-- local completion_kinds = vim.lsp.protocol.CompletionItemKind
-- for i, kind in ipairs(completion_kinds) do
--     completion_kinds[i] = icons[kind] and icons[kind] .. kind or kind
-- end

--- On attach
---
local function on_attach(client, buf)
    local capabilities = client.server_capabilities
    local formatting = {
        available = capabilities.document_formatting,
        range = capabilities.document_range_formatting,
    }

    -- Enable omnifunc-completion
    vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"

    -- if client.supports_method('textDocument/completion') then
    --     vim.lsp.completion.enable(true, client.id, bufnr, {autotrigger = true})
    -- end

    --- Keybindings
    --- Autocommands
    vim.api.nvim_create_augroup("Lsp", { clear = true })
    -- Display line diagnostics on hover
    vim.api.nvim_create_autocmd("CursorHold", {
        group = "Lsp",
        buffer = buf,
        callback = function()
            local opts = {
                focusable = false,
                close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
                border = "rounded",
                source = "always",
                prefix = " ",
                scope = "line",
            }
            vim.diagnostic.open_float(opts)
        end,
    })
    -- if client.supports_method("textDocument/formatting") then
    --     vim.api.nvim_create_autocmd('BufWritePre', {
    --         buffer = buf,
    --         callback = function()
    --             vim.lsp.buf.format({ bufnr = buf, id = client.id })
    --         end,
    --     })
    -- end
end

--- Capabilities
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local skCapabilities = require('cmp_nvim_lsp').default_capabilities()
capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
}
skCapabilities = {
    workspace = {
        didChangeWatchedFiles = {
            dynamicRegistration = true
        }
    }
}

--- Setup servers
local defaults = {
    on_attach = on_attach,
    capabilities = capabilities,
    flags = { debounce_text_changes = 150 },
}

local mac = vim.fn.OSX()
if mac == 1 then
    if vim.fn.executable("sourcekit-lsp") == 1 then
        lsp.sourcekit.setup {
            cmd = { "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/sourcekit-lsp" },
            on_attach = on_attach,
            capabilities = skCapabilities,
            root_dir = require 'lspconfig'.util.root_pattern("Package.swift", ".git"),
        }

        local function refresh_xcodeproj()
            io.popen("~/Documents/GitHub/grindr/scripts/nvim_clean.sh")
        end
        vim.api.nvim_create_user_command("Xcrefresh", refresh_xcodeproj, {
            desc = "Clean, build, and generate buildServer.json for the grindr project.",
        })
        local function remake_buildserver()
            os.execute(
                'cd ~/Documents/GitHub/grindr & xcode-build-server config -scheme Grindr -workspace *.xcworkspace')
            io.popen("~/Documents/GitHub/grindr/scripts/nvim_clean.sh")
        end
        vim.api.nvim_create_user_command("Xcbuildserver", remake_buildserver, {
            desc = "Generate buildServer.json for the grindr project.",
        })
    end
else
    if vim.fn.executable("sourcekit-lsp") == 1 then
        lsp.sourcekit.setup {
            on_attach = on_attach,
            capabilities = skCapabilities,
            root_dir = require 'lspconfig'.util.root_pattern("Package.swift"),
            filetypes = { "swift" },
        }
    end
end

-- C/C++
-- if vim.fn.executable("clangd") == 1 then
--     local clangd_defaults = require("lspconfig.server_configurations.clangd")
--     local clangd_configs = vim.tbl_deep_extend("force", clangd_defaults.default_config, defaults, {
--         cmd = {
--             "clangd",
--             "-j=4",
--             "--background-index",
--             "--clang-tidy",
--             "--inlay-hints",
--             "--fallback-style=llvm",
--             "--all-scopes-completion",
--             "--completion-style=detailed",
--             "--header-insertion=iwyu",
--             "--header-insertion-decorators",
--             "--pch-storage=memory",
--         },
--     })
--     -- require("clangd_extensions").setup({ server = clangd_configs })
-- end

-- Java
if vim.fn.executable("jdtls") == 1 then
    lsp.jdtls.setup(defaults)
end

-- Zig
if vim.fn.executable("zls") == 1 then
    lsp.zls.setup(defaults)
end

-- Rust, now managed by rustaceanvim
-- if vim.fn.executable("rust-analyzer") == 1 then
--     lsp.rust_analyzer.setup(defaults)
-- end

-- JavaScript/TypeScript
if vim.fn.executable("tsserver") == 1 then
    local settings = {
        settings = {
            javascript = {
                inlayHints = {
                    includeInlayEnumMemberValueHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                    includeInlayFunctionParameterTypeHints = true,
                    includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
                    includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayVariableTypeHints = true,
                },
            },
            typescript = {
                inlayHints = {
                    includeInlayEnumMemberValueHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                    includeInlayFunctionParameterTypeHints = true,
                    includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
                    includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayVariableTypeHints = true,
                },
            },
        },
    }
    settings = vim.tbl_deep_extend("force", defaults, settings)
    lsp.tsserver.setup(settings)
end

-- Vue
-- Installation: npm i -g @volar/vue-language-server
if vim.fn.executable("vue-language-server") == 1 then
    lsp.volar.setup(defaults)
end

-- ESLint, linting engine for JavaScript/TypeScript
-- Installation: npm i -g vscode-langservers-extracted
if vim.fn.executable("vscode-eslint-language-server") == 1 then
    lsp.eslint.setup(defaults)
end

-- CSS
-- Installation: npm i -g vscode-langservers-extracted
if vim.fn.executable("vscode-css-language-server") == 1 then
    lsp.cssls.setup(defaults)
end

-- TailwindCSS
-- Installation: npm i -g @tailwindcss/language-server
if vim.fn.executable("tailwindcss-language-server") == 1 then
    lsp.tailwindcss.setup(defaults)
end

if vim.fn.executable("nil") == 1 then
    lsp.nil_ls.setup(defaults)
end

-- HTML
-- Installation: npm i -g vscode-langservers-extracted
-- if vim.fn.executable("vscode-html-language-server") == 1 then
--     lsp.html.setup(defaults)
-- end

-- Lua
if vim.fn.executable("lua-language-server") == 1 then
    -- I am installing lua LS through brew instead of manually compiling it like on my Linux machines.
    -- However, sometimes I use package managers to install lua lsp on my Linux machines so we gotta double check it
    if jit.os == "OSX" or vim.fn.executable("/usr/bin/lua-language-server") == 1 then
        local lua_config = {
            settings = {
                Lua = {
                    hint = {
                        enable = true,
                    },
                    runtime = {
                        version = "LuaJIT",
                    },
                    diagnostics = {
                        globals = { "_G", "vim" },
                    },
                    workspace = {
                        preloadFileSize = 500,
                    },
                },
            },
        }
        lua_config.cmd = { "lua-language-server" }
        lsp.lua_ls.setup(vim.tbl_deep_extend("force", defaults, lua_config))
    else
        lsp.lua_ls.setup(defaults)
    end
end

-- Elixir
if vim.fn.executable("elixir-ls") == 1 then
    lsp.elixirls.setup(
        vim.tbl_deep_extend("force", defaults, { cmd = { vim.env.HOME .. "/.local/bin/elixir-ls" } })
    )
end

-- Python
if vim.fn.executable("jedi-language-server") == 1 then
    lsp.jedi_language_server.setup(defaults)
end

-- Disable diagnostics in insert and select mode
vim.api.nvim_create_autocmd('ModeChanged', {
    pattern = { 'n:i', 'v:s' },
    desc = 'Disable diagnostics in insert and select mode',
    callback = function(e) vim.diagnostic.disable(e.buf) end
})

require("lspconfig")["gdscript"].setup({
    name = "godot",
    cmd = vim.lsp.rpc.connect("127.0.0.1", "6005")
})

local dap = require("dap") dap.adapters.godot = { type = "server", host = "127.0.0.1", port = 6006, }
dap.configurations.gdscript = { { type = "godot", request = "launch", name = "Launch scene", project = "${workspaceFolder}", launch_scene = true, }, }

vim.api.nvim_create_autocmd('ModeChanged', {
    pattern = 'i:n',
    desc = 'Enable diagnostics when leaving insert mode',
    callback = function(e) vim.diagnostic.enable(e.buf) end
})

-- -- Enable inlay hints
-- vim.api.nvim_create_autocmd('LspAttach', {
--     desc = 'Enable inlay hints',
--     callback = function(event)
--         local id = vim.tbl_get(event, 'data', 'client_id')
--         local client = id and vim.lsp.get_client_by_id(id)
--         if client == nil or not client.supports_method('textDocument/inlayHint') then
--             return
--         end
--
--         -- warning: this api is not stable yet
--         vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
--     end,
-- })
--
-- Toggle lsp client
local function toggle_lsp_client()
    local buf = vim.api.nvim_get_current_buf()
    local clients = vim.lsp.get_clients({ bufnr = buf })
    if not vim.tbl_isempty(clients) then
        vim.cmd("LspStop")
        vim.notify("[nvim] LSP client has been temporarily disabled in this buffer")
    else
        vim.cmd("LspStart")
        vim.notify("[nvim] LSP client has been enabled again in this buffer")
    end
end

vim.api.nvim_create_user_command("LspToggle", toggle_lsp_client, {
    desc = "Toggle LSP for the current buffer",
})

vim.keymap.set("n", "<leader>le", "<cmd>LspToggle<cr>", {
    desc = "Toggle LSP client",
})
