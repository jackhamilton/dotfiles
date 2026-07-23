return {
    {
        "mfussenegger/nvim-dap",
        event = 'LspAttach',
        keys = {
            {
                "Ds",
                mode = "n",
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
                "Dc",
                mode = "n",
                function()
                    require("dap").continue()
                end,
                desc = "continue",
                nowait = true,
                remap = false,
            },
            {
                "Di",
                mode = "n",
                function()
                    require("dap").step_into()
                end,
                desc = "Step Into",
                nowait = true,
                remap = false,
            },
            {
                "Do",
                mode = "n",
                function()
                    require("dap").step_over()
                end,
                desc = "Step Over",
                nowait = true,
                remap = false,
            },
            {
                "Du",
                mode = "n",
                function()
                    require("dap").step_out()
                end,
                desc = "Step Out",
                nowait = true,
                remap = false,
            },
            {
                "Dr",
                mode = "n",
                function()
                    require("dap").repl.open()
                end,
                desc = "Open REPL",
                nowait = true,
                remap = false,
            },
            {
                "Dl",
                mode = "n",
                function()
                    require("dap").run_last()
                end,
                desc = "Run Last",
                nowait = true,
                remap = false,
            },
            {
                "Dq",
                mode = "n",
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
                "DC",
                mode = "n",
                function()
                    require("dap").clear_breakpoints()
                end,
                desc = "Clear Breakpoints",
                nowait = true,
                remap = false,
            },
            {
                "Dx",
                mode = "n",
                function()
                    require("dap").run_to_cursor()
                end,
                desc = "Run to Cursor",
                nowait = true,
                remap = false,
            },
            {
                "De",
                mode = "n",
                function()
                    require("dap").set_exception_breakpoints({ "all" })
                end,
                desc = "Set Exception Breakpoints",
                nowait = true,
                remap = false,
            },
            {
                "Db",
                mode = "n",
                function()
                    require("dap").toggle_breakpoint()
                end,
                desc = "Toggle Breakpoint"
            },
            {
                "DB",
                mode = "n",
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
                "Dt",
                mode = "n",
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
                            { id = "watches", size = 0.67 },
                            { id = "stacks",  size = 0.33 },
                        },
                        position = "bottom",
                        size = 10,
                    }
                },
                wrap = false,
                icons = {
                    collapsed = "",
                    expanded = "",
                    current_frame = "󰜴"
                },
            })

            require("nvim-dap-virtual-text").setup({
                virt_text_pos = 'inline'
            })

            local dap, dapui = require("dap"), require("dapui")

            local function set_dapui_highlights()
                vim.api.nvim_set_hl(0, "DapUIStoppedThread", { bold = true, reverse = true })
                vim.api.nvim_set_hl(0, "DapUICurrentFrameName", { bold = true, underline = true })
            end

            set_dapui_highlights()
            vim.api.nvim_create_autocmd("ColorScheme", {
                group = vim.api.nvim_create_augroup("dapui_highlights", { clear = true }),
                callback = set_dapui_highlights,
            })

            local system_source_roots = {
                "/Applications/Xcode.app/",
                "/Library/Developer/CoreSimulator/",
                "/System/Library/",
                "/usr/lib/",
            }

            local function is_system_frame(frame)
                local path = frame.source and frame.source.path
                if not path then
                    return true
                end

                for _, root in ipairs(system_source_roots) do
                    if path:sub(1, #root) == root then
                        return true
                    end
                end

                return false
            end

            -- lldb-dap does not mark Apple/runtime frames as subtle, so dap-ui
            -- otherwise renders the complete SwiftUI/UIKit stack by default.
            dap.listeners.before.stackTrace["dapui_system_frames"] = function(session, err, response, request)
                if err or not response or not response.stackFrames then
                    return
                end

                local current_frame_id = session.current_frame and session.current_frame.id
                for index, frame in ipairs(response.stackFrames) do
                    local is_current = frame.id == current_frame_id
                        or (request.threadId == session.stopped_thread_id and index == 1)

                    if not is_current and is_system_frame(frame) then
                        frame.presentationHint = "subtle"
                    end
                end
            end

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
