local lsp = require("lspconfig")

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
    local kbd = vim.keymap.set
    -- Show documentation
    kbd("n", "<leader>lh", vim.lsp.buf.hover, { buffer = true, desc = "Hover documentation" })
    -- Open code actions
    kbd("n", "<leader>la", vim.lsp.buf.code_action, { buffer = true, desc = "Code actions" })
    -- Rename symbol under cursor
    kbd("n", "<leader>lr", vim.lsp.buf.rename, { buffer = true, desc = "Rename" })
    -- Show line diagnostics
    kbd("n", "<leader>ldl", function()
        vim.diagnostic.open_float({
            focusable = false,
            close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
            border = "rounded",
            source = "always",
            prefix = " ",
            scope = "cursor",
        })
    end, { buffer = true, desc = "Show line diagnostics" })
    -- Go to diagnostics
    kbd(
        "n",
        "<leader>ldp",
        vim.diagnostic.goto_prev,
        { buffer = true, desc = "Goto next diagnostic" }
    )
    kbd(
        "n",
        "<leader>ldn",
        vim.diagnostic.goto_next,
        { buffer = true, desc = "Goto prev diagnostic" }
    )
    -- Go to definition
    kbd("n", "<leader>lgd", vim.lsp.buf.definition, { buffer = true, desc = "Goto definition" })
    -- Go to declaration
    kbd("n", "<leader>lgD", vim.lsp.buf.declaration, { buffer = true, desc = "Goto declaration" })
    kbd("n", "<leader>li", vim.lsp.buf.implementation, { buffer = true, desc = "List implementations" })
    kbd("n", "<leader>lss", vim.lsp.buf.workspace_symbol, { buffer = true, desc = "Workspace symbol search" })
    kbd("n", "<leader>lgt", vim.lsp.buf.type_definition, { buffer = true, desc = "Goto type definition" })
    -- kbd("n", "<leader>lgh", vim.lsp.buf.type_hierarchy, { buffer = true, desc = "Show type hierarchy" })
    kbd("n", "<leader>lgr", vim.lsp.buf.references, { buffer = true, desc = "List references" })
    kbd("n", "<leader>lgo", vim.lsp.buf.outgoing_calls, { buffer = true, desc = "List outgoing calls" })

    kbd("n", "<leader>lts", '<cmd>Telescope lsp_workspace_symbols<cr>', { buffer = true, desc = "Symbol search" })
    kbd("n", "<leader>ltS", '<cmd>Telescope lsp_dynamic_workspace_symbols<cr>',
        { buffer = true, desc = "Symbol search (all workspace)" })
    kbd("n", "<leader>ltr", '<cmd>Telescope lsp_references<cr>', { buffer = true, desc = "References" })
    kbd("n", "<leader>lsf", vim.lsp.buf.declaration, { buffer = true, desc = "Display function signature" })
    kbd("n", "<leader>lf", vim.lsp.buf.format, { buffer = true, desc = "Format file" })
    kbd("n", "<leader>lsh", vim.lsp.buf.signature_help, { buffer = true, desc = "Symbol signature help" })

    -- local wk = require("which-key")
    -- wk.register({
    --     l = {
    --         g = {
    --             name = "Goto",
    --         },
    --         s = {
    --             name = "Search",
    --         },
    --         t = {
    --             name = "Telescope",
    --         },
    --         d = {
    --             name = "Diagnostics",
    --         },
    --     },
    -- }, { prefix = "<leader>" })

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
    if client.supports_method("textDocument/formatting") then
        vim.api.nvim_create_autocmd('BufWritePre', {
            buffer = buf,
            callback = function()
                vim.lsp.buf.format({ bufnr = buf, id = client.id })
            end,
        })
    end
end

--- Capabilities
local capabilities = require('cmp_nvim_lsp').default_capabilities()
capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
}
local skCapabilities = capabilities
skCapabilities.textDocument.foldingRange = {
    dynamicRegistration = true
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
        -- local coq = require "coq"
        -- lsp.sourcekit.setup(coq.lsp_ensure_capabilities {})

        local function refresh_xcodeproj()
            io.popen("~/Documents/GitHub/grindr/scripts/nvim_clean.sh")
        end
        vim.api.nvim_create_user_command("Xcrefresh", refresh_xcodeproj, {
            desc = "Clean, build, and generate buildServer.json for the grindr project.",
        })
    end
else
    if vim.fn.executable("sourcekit-lsp") == 1 then
        lsp.sourcekit.setup {
            on_attach = on_attach,
            capabilities = skCapabilities,
            root_dir = require 'lspconfig'.util.root_pattern("Package.swift", ".git"),
        }
        -- local coq = require "coq"
        -- lsp.sourcekit.setup(coq.lsp_ensure_capabilities {})
    end
end

-- C/C++
if vim.fn.executable("clangd") == 1 then
    local clangd_defaults = require("lspconfig.server_configurations.clangd")
    local clangd_configs = vim.tbl_deep_extend("force", clangd_defaults.default_config, defaults, {
        cmd = {
            "clangd",
            "-j=4",
            "--background-index",
            "--clang-tidy",
            "--inlay-hints",
            "--fallback-style=llvm",
            "--all-scopes-completion",
            "--completion-style=detailed",
            "--header-insertion=iwyu",
            "--header-insertion-decorators",
            "--pch-storage=memory",
        },
    })
    -- require("clangd_extensions").setup({ server = clangd_configs })
end

-- Java
if vim.fn.executable("jdtls") == 1 then
    lsp.jdtls.setup(defaults)
    -- local coq = require "coq"
    -- lsp.jdtls.setup(coq.lsp_ensure_capabilities {})
end

-- Zig
if vim.fn.executable("zls") == 1 then
    lsp.zls.setup(defaults)
    -- local coq = require "coq"
    -- lsp.zls.setup(coq.lsp_ensure_capabilities {})
end

-- Rust, now managed by rustaceanvim
-- if vim.fn.executable("rust-analyzer") == 1 then
--   lsp.rust_analyzer.setup(defaults)
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
    -- local coq = require "coq"
    -- lsp.tsserver.setup(coq.lsp_ensure_capabilities {})
end

-- Vue
-- Installation: npm i -g @volar/vue-language-server
if vim.fn.executable("vue-language-server") == 1 then
    lsp.volar.setup(defaults)
    -- local coq = require "coq"
    -- lsp.volar.setup(coq.lsp_ensure_capabilities {})
end

-- ESLint, linting engine for JavaScript/TypeScript
-- Installation: npm i -g vscode-langservers-extracted
if vim.fn.executable("vscode-eslint-language-server") == 1 then
    lsp.eslint.setup(defaults)
    -- local coq = require "coq"
    -- lsp.eslint.setup(coq.lsp_ensure_capabilities {})
end

-- CSS
-- Installation: npm i -g vscode-langservers-extracted
if vim.fn.executable("vscode-css-language-server") == 1 then
    lsp.cssls.setup(defaults)
    -- local coq = require "coq"
    -- lsp.cssls.setup(coq.lsp_ensure_capabilities {})
end

-- TailwindCSS
-- Installation: npm i -g @tailwindcss/language-server
if vim.fn.executable("tailwindcss-language-server") == 1 then
    lsp.tailwindcss.setup(defaults)
    -- local coq = require "coq"
    -- lsp.tailwindcss.setup(coq.lsp_ensure_capabilities {})
end

-- HTML
-- Installation: npm i -g vscode-langservers-extracted
if vim.fn.executable("vscode-html-language-server") == 1 then
    lsp.html.setup(defaults)
    -- local coq = require "coq"
    -- lsp.html.setup(coq.lsp_ensure_capabilities {})
end

-- Lua
if vim.fn.executable("lua-language-server") == 1 then
    local lua_config = {
        cmd = {
            "lua-language-server",
            "-E",
            -- MARK: causing issues on linux
            vim.env.HOME .. "/Develop/Nvim/lua-language-server/main.lua",
        },
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
    -- I am installing lua LS through brew instead of manually compiling it like on my Linux machines.
    -- However, sometimes I use package managers to install lua lsp on my Linux machines so we gotta double check it
    if jit.os == "OSX" or vim.fn.executable("/usr/bin/lua-language-server") == 1 then
        lua_config.cmd = { "lua-language-server" }
    end

    lsp.lua_ls.setup(vim.tbl_deep_extend("force", defaults, lua_config))
    -- local coq = require "coq"
    -- lsp.lua_ls.setup(coq.lsp_ensure_capabilities {})
end

-- Elixir
if vim.fn.executable("elixir-ls") == 1 then
    lsp.elixirls.setup(
        vim.tbl_deep_extend("force", defaults, { cmd = { vim.env.HOME .. "/.local/bin/elixir-ls" } })
    )
    -- local coq = require "coq"
    -- lsp.elixirls.setup(coq.lsp_ensure_capabilities {})
end

-- Python
if vim.fn.executable("jedi-language-server") == 1 then
    lsp.jedi_language_server.setup(defaults)
    -- local coq = require "coq"
    -- lsp.jedi_language_server.setup(coq.lsp_ensure_capabilities {})
end

-- Disable diagnostics in insert and select mode
vim.api.nvim_create_autocmd('ModeChanged', {
    pattern = { 'n:i', 'v:s' },
    desc = 'Disable diagnostics in insert and select mode',
    callback = function(e) vim.diagnostic.disable(e.buf) end
})

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
