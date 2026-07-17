return {
    {
        "mfussenegger/nvim-dap",
        event = 'LspAttach',
        keys = {
            {
                "<leader>d",
                group = "Debugger",
                nowait = true,
                remap = false,
            },
            {
                "<leader>ds",
                mode = { "n", "v", "x" },
                function()
                    if vim.bo.filetype == "swift" then
                        require("xcodebuild.integrations.dap").build_and_debug()
                    else
                        require("dap").continue()
                    end
                end,
                desc = "start",
                nowait = true,
                remap = false,
            },
            {
                "<leader>dc",
                mode = { "n", "v", "x" },
                function()
                    require("dap").continue()
                end,
                desc = "continue",
                nowait = true,
                remap = false,
            },
            {
                "<leader>di",
                mode = { "n", "v", "x" },
                function()
                    require("dap").step_into()
                end,
                desc = "Step Into",
                nowait = true,
                remap = false,
            },
            {
                "<leader>do",
                mode = { "n", "v", "x" },
                function()
                    require("dap").step_over()
                end,
                desc = "Step Over",
                nowait = true,
                remap = false,
            },
            {
                "<leader>du",
                mode = { "n", "v", "x" },
                function()
                    require("dap").step_out()
                end,
                desc = "Step Out",
                nowait = true,
                remap = false,
            },
            {
                "<leader>dr",
                mode = { "n", "v", "x" },
                function()
                    require("dap").repl.open()
                end,
                desc = "Open REPL",
                nowait = true,
                remap = false,
            },
            {
                "<leader>dl",
                mode = { "n", "v", "x" },
                function()
                    require("dap").run_last()
                end,
                desc = "Run Last",
                nowait = true,
                remap = false,
            },
            {
                "<leader>dq",
                mode = { "n", "v", "x" },
                function()
                    require("dap").terminate()
                    require("dapui").close()
                    require("nvim-dap-virtual-text").disable()
                end,
                desc = "Terminate",
                nowait = true,
                remap = false,
            },
            {
                "<leader>dC",
                mode = { "n", "v", "x" },
                function()
                    require("dap").clear_breakpoints()
                end,
                desc = "Clear Breakpoints",
                nowait = true,
                remap = false,
            },
            {
                "<leader>dx",
                mode = { "n", "v", "x" },
                function()
                    require("dap").run_to_cursor()
                end,
                desc = "Run to Cursor",
                nowait = true,
                remap = false,
            },
            {
                "<leader>de",
                mode = { "n", "v", "x" },
                function()
                    require("dap").set_exception_breakpoints({ "all" })
                end,
                desc = "Set Exception Breakpoints",
                nowait = true,
                remap = false,
            },
            {
                "<leader>db",
                mode = { "n", "v", "x" },
                function()
                    require("dap").toggle_breakpoint()
                end,
                desc = "Toggle Breakpoint"
            },
            {
                "<leader>dB",
                mode = { "n", "v", "x" },
                function()
                    require("dap").list_breakpoints(false)
                    require("snacks").picker.qflist({ title = "Breakpoints" })
                end,
                desc = "List Breakpoints"
            }

        },
    },
    {
        "rcarriga/nvim-dap-ui",
        dependencies = {
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio",
            "theHamsta/nvim-dap-virtual-text"
        },
        lazy = true,
        keys = {
            {
                "<leader>dt",
                mode = { "n", "v", "x" },
                function()
                    require("dapui").toggle()
                end,
                desc = "Toggle"
            },
            {
                "<leader>dw",
                mode = { "x" },
                function()
                    require("dapui").elements.watches.add()
                end,
                desc = "Watch selection"
            },
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
                layouts = {
                    {
                        elements = {
                            { id = "watches", size = 0.75 },
                            { id = "stacks",  size = 0.25 },
                        },
                        position = "bottom",
                        size = 10,
                    }
                },
                wrap = true,
                icons = {
                    collapsed = "",
                    expanded = "",
                    current_frame = ""
                },
            })

            require("nvim-dap-virtual-text").setup({
                virt_text_pos = 'inline'
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
