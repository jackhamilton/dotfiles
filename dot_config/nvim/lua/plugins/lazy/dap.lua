return {
    {
        "mfussenegger/nvim-dap",
        event = 'LspAttach',
    },
    {
        "rcarriga/nvim-dap-ui",
        dependencies = {
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio",
        },
        lazy = true,
        keys = {
            {
                "<leader>Do",
                mode = "n",
                function()
                    require("dapui").open()
                end,
                desc = "Open"
            },
            {
                "<leader>Dc",
                mode = "n",
                function()
                    require("dapui").close()
                end,
                desc = "Close"
            },
            {
                "<leader>Dt",
                mode = "n",
                function()
                    require("dapui").toggle()
                end,
                desc = "Toggle"
            },
            {
                "<leader>Db",
                mode = "n",
                function()
                    require("dap").toggle_breakpoint()
                end,
                desc = "Breakpoint"
            }
        },
        config = function()
            require("dapui").setup({
                controls = {
                    element = "repl",
                    enabled = true,
                },
                floating = {
                    border = "single",
                    mappings = {
                        close = { "q", "<Esc>" },
                    },
                },
                icons = { collapsed = "", expanded = "", current_frame = "" },
                layouts = {
                    {
                        elements = {
                            { id = "stacks",      size = 0.25 },
                            { id = "scopes",      size = 0.25 },
                            { id = "breakpoints", size = 0.25 },
                            { id = "watches",     size = 0.25 },
                        },
                        position = "left",
                        size = 60,
                    },
                    {
                        elements = {
                            { id = "repl",    size = 0.35 },
                            { id = "console", size = 0.65 },
                        },
                        position = "bottom",
                        size = 10,
                    },
                },
            })

            local dap, dapui = require("dap"), require("dapui")

            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end
        end,
    },
}
