return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
        bigfile = { enabled = true },
        explorer = { enabled = true },
        indent = { enabled = true },
        input = { enabled = true },
        notifier = {
            enabled = true,
            timeout = 3000,
        },
        picker = { enabled = true },
        quickfile = { enabled = true },
        scope = { enabled = true },
        scroll = { enabled = false },
        statuscolumn = {
            left = { "mark", "sign" }, -- priority of signs on the left (high to low)
            right = { "fold", "git" }, -- priority of signs on the right (high to low)
            folds = {
                open = false, -- show open fold icons
                git_hl = false, -- use Git Signs hl for fold icons
            },
            git = {
                -- patterns to match Git signs
                patterns = { "GitSign", "MiniDiffSign" },
            },
            refresh = 50, -- refresh at most every 50ms
            enabled = true
        },
        words = { enabled = true },
        dashboard = {
            enabled = true,
            sections = {
                { section = "header" },
                {
                    pane = 2,
                    section = "terminal",
                    cmd = "if command -v colorscript; then\ncolorscript -e square\nfi",
                    height = 5,
                    padding = 1,
                },
                { section = "keys", gap = 1, padding = 1 },
                {
                    pane = 2,
                    icon = " ",
                    desc = "Browse Repo",
                    padding = 1,
                    key = "b",
                    action = function()
                        Snacks.gitbrowse()
                    end,
                },
                function()
                    local in_git = Snacks.git.get_root() ~= nil
                    local cmds = {
                        {
                            title = "Notifications",
                            cmd = "gh notify -s -ap -n5 -e \"review_requested\"",
                            action = function()
                                vim.ui.open("https://github.com/notifications")
                            end,
                            key = "n",
                            icon = " ",
                            height = 5,
                            enabled = true,
                        },
                        {
                            title = "Open Issues",
                            cmd = "gh issue list -L 3",
                            key = "i",
                            action = function()
                                vim.fn.jobstart("gh issue list --web", { detach = true })
                            end,
                            icon = " ",
                            height = 7,
                        },
                        {
                            icon = " ",
                            title = "Open PRs",
                            cmd = "gh pr list -L 3",
                            key = "p",
                            action = function()
                                vim.fn.jobstart("gh pr list --web", { detach = true })
                            end,
                            height = 7,
                        },
                        {
                            icon = " ",
                            title = "Git Status",
                            cmd = "git --no-pager diff --stat -B -M -C",
                            height = 10,
                        },
                    }
                    return vim.tbl_map(function(cmd)
                        return vim.tbl_extend("force", {
                            pane = 2,
                            section = "terminal",
                            enabled = in_git,
                            padding = 1,
                            ttl = 5 * 60,
                            indent = 3,
                        }, cmd)
                    end, cmds)
                end,
                { section = "startup" },
            },
        }
    },
    keys = {
        {
            "<leader>gg",
            mode = { "n" },
            function()
                ---@param opts? snacks.lazygit.Config
                Snacks.lazygit.open(opts)
            end,
            desc = "Lazygit"
        },
        {
            "<leader>go",
            mode = { "n" },
            function()
                ---@param opts? snacks.gitbrowse.Config
                Snacks.gitbrowse.open(opts)
            end,
            desc = "Open branch in browser"
        },
        {
            "<leader>fr",
            mode = { "n" },
            function()
                Snacks.rename.rename_file()
            end,
            desc = "Rename file"
        },
        { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
        { "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers" },
        { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep" },

        { "<leader>hn", function() Snacks.picker.notifications() end, desc = "Notification History" },
        { "<leader>hc", function() Snacks.picker.command_history() end, desc = "Command History" },
        -- find
        { "<leader>fe", function() Snacks.explorer() end, desc = "File Explorer" },
        { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
        { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
        { "<leader>fF", function() Snacks.picker.files() end, desc = "Find Files" },
        { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Git Files" },
        { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
        { "<leader>fR", function() Snacks.picker.recent() end, desc = "Recent" },
        { "<leader>fC", function() Snacks.explorer.reveal() end, desc = "Reveal current" },
        -- git
        { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
        { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log" },
        { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
        { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
        { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
        { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" },
        { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
        { "<leader>gr", function() Snacks.gitbrowse.open() end, desc = "Open repository" },
        -- Grep
        { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
        { "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
        { "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep" },
        { "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },
        -- search
        { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
        { '<leader>s/', function() Snacks.picker.search_history() end, desc = "Search History" },
        { "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
        { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
        { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History" },
        { "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },
        { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
        { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
        { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
        { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights" },
        { "<leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
        { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps" },
        { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
        { "<leader>sl", function() Snacks.picker.loclist() end, desc = "Location List" },
        { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
        { "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },
        { "<leader>sp", function() Snacks.picker.lazy() end, desc = "Search for Plugin Spec" },
        { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
        { "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume" },
        { "<leader>su", function() Snacks.picker.undo() end, desc = "Undo History" },
        -- buffers
        { "<leader>bd", function() Snacks.picker.undo() end, desc = "Delete buffer" },
        { "<leader>bl", function() Snacks.picker.buffers() end, desc = "List buffers" },
        { "<leader>ba", function() Snacks.picker.buffers() end, desc = "Clear buffers" },
        { "<leader>bo", function() Snacks.picker.buffers() end, desc = "Clear other buffers" },
        { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
        -- intent
        { "<leader>ie", function() Snacks.indent.enable() end, desc = "Enable indents" },
        { "<leader>id", function() Snacks.indent.disable() end, desc = "Disable indents" },
        -- scope
        { "<leader>lSa", function() Snacks.scope.attach() end, desc = "Attach" },
        { "<leader>lSg", function() Snacks.scope.get() end, desc = "Get scope" },
        { "<leader>lSj", function() Snacks.scope.jump() end, desc = "Jump scope" },
        -- scratch
        { "<leader>.",  function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
        -- toggle
        { "<leader>tt", function() Snacks.toggle() end, desc = "Toggle" },
        { "<leader>ta", function() Snacks.toggle.animate() end, desc = "Animate" },
        { "<leader>td", function() Snacks.toggle.diagnostics() end, desc = "Diagnostics" },
        { "<leader>tD", function() Snacks.toggle.dim() end, desc = "Dim" },
        { "<leader>tg", function() Snacks.toggle.get() end, desc = "Get" },
        { "<leader>ti", function() Snacks.toggle.indent() end, desc = "Indent" },
        { "<leader>tI", function() Snacks.toggle.inlay_hints() end, desc = "Inlay hints" },
        { "<leader>tl", function() Snacks.toggle.line_number() end, desc = "Line number" },
        { "<leader>tn", function() Snacks.toggle.new() end, desc = "New" },
        { "<leader>to", function() Snacks.toggle.option() end, desc = "Option" },
        { "<leader>tp", function() Snacks.toggle.profiler() end, desc = "Profiler" },
        { "<leader>tH", function() Snacks.toggle.profiler_highlights() end, desc = "Profiler Highlights" },
        { "<leader>ts", function() Snacks.toggle.scroll() end, desc = "Scroll" },
        { "<leader>tt", function() Snacks.toggle.treesitter() end, desc = "Treesitter" },
        { "<leader>tw", function() Snacks.toggle.words() end, desc = "Words" },
        { "<leader>tz", function() Snacks.toggle.zen() end, desc = "Zen" },
        { "<leader>tZ", function() Snacks.toggle.zoom() end, desc = "Zoom" },
        -- LSP
        -- { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
        -- { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
        -- { "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
        -- { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
        -- { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
        -- { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
        -- { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
    },
    init = function()
        vim.api.nvim_create_autocmd("User", {
            pattern = "VeryLazy",
            callback = function()
                -- Setup some globals for debugging (lazy-loaded)
                _G.dd = function(...)
                    Snacks.debug.inspect(...)
                end
                _G.bt = function()
                    Snacks.debug.backtrace()
                end
                vim.print = _G.dd -- Override print to use snacks for `:=` command
            end,
        })
    end,
}
