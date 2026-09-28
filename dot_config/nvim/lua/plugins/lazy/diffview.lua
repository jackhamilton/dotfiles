local function open_containing_fold_at_cursor()
    local win = vim.api.nvim_get_current_win()
    require("utils.origami_outline").openContainingFolds(win, vim.api.nvim_win_get_cursor(win)[1])
end

local function next_inline_hunk()
    require("diffview.actions").next_inline_hunk()
    vim.schedule(open_containing_fold_at_cursor)
end

local function previous_inline_hunk()
    require("diffview.actions").prev_inline_hunk()
    vim.schedule(open_containing_fold_at_cursor)
end

local function open_changed_diff_folds(bufnr, winid)
    local outline = require("utils.origami_outline")
    if vim.api.nvim_win_is_valid(winid) then
        vim.api.nvim_win_call(winid, function()
            if vim.wo.diff then
                for line = 1, vim.api.nvim_buf_line_count(bufnr) do
                    if vim.fn.diff_hlID(line, 1) ~= 0 then
                        outline.openContainingFolds(winid, line)
                    end
                end
            else
                local inline_diff = require("diffview.scene.inline_diff")
                for _, hunk in ipairs(inline_diff.get_hunks(bufnr) or {}) do
                    outline.openContainingFolds(winid, hunk[3])
                end
            end
        end)
    end
end

local function refresh_origami_folds(bufnr, winid)
    require("utils.origami_outline").refresh(bufnr, winid, { force = true, noRetry = true, diffview = true })
    open_changed_diff_folds(bufnr, winid)
end

local function schedule_changed_diff_folds(bufnr, winid)
    vim.defer_fn(function()
        if vim.api.nvim_buf_is_valid(bufnr) and vim.api.nvim_win_is_valid(winid) then
            open_changed_diff_folds(bufnr, winid)
        end
    end, 50)
end

local function refresh_all_diffview_folds()
    for _, winid in ipairs(vim.api.nvim_list_wins()) do
        local bufnr = vim.api.nvim_win_get_buf(winid)
        local name = vim.api.nvim_buf_get_name(bufnr)
        if name:match("^diffview://") and not name:match("/panels/") then
            refresh_origami_folds(bufnr, winid)
        end
    end
end

return {
    {
        "dlyongemallo/diffview-plus.nvim",
        init = function()
            vim.api.nvim_create_autocmd("BufWinEnter", {
                group = vim.api.nvim_create_augroup("diffview_origami_folds", { clear = true }),
                pattern = "diffview://*",
                callback = function(args)
                    vim.schedule(function()
                        local winid = vim.fn.bufwinid(args.buf)
                        if winid ~= -1 and not vim.api.nvim_buf_get_name(args.buf):match("/panels/") then
                            refresh_origami_folds(args.buf, winid)
                            schedule_changed_diff_folds(args.buf, winid)
                        end
                    end)
                end,
            })
        end,
        keys = {
            { "<leader>jC", "<Cmd>DiffviewClose<CR>", desc = "Close diff view" },
        },
        opts = {
            preferred_adapter = "jj",
            enhanced_diff_hl = true,
            view = {
                default = {
                    layout = "diff1_inline",
                },
                file_history = {
                    layout = "diff1_inline",
                },
                inline = {
                    style = "overleaf",
                    fold_unchanged = false,
                },
                cycle_layouts = {
                    default = {
                        "diff2_horizontal",
                        "diff1_inline",
                        "diff2_vertical",
                        "diff1_plain",
                    },
                },
            },
            hooks = {
                view_post_layout = refresh_all_diffview_folds,
                diff_buf_win_enter = function(bufnr, winid)
                    refresh_origami_folds(bufnr, winid)
                end,
            },
            keymaps = {
                diff1_inline = {
                    { "n", "<PageDown>", next_inline_hunk, { desc = "Jump to the next inline-diff hunk and open folds" } },
                    { "n", "<PageUp>", previous_inline_hunk, { desc = "Jump to the previous inline-diff hunk and open folds" } },
                    { "n", "]c", next_inline_hunk, { desc = "Jump to the next inline-diff hunk and open folds" } },
                    { "n", "[c", previous_inline_hunk, { desc = "Jump to the previous inline-diff hunk and open folds" } },
                },
            },
            file_panel = {
                listing_style = "tree",
                win_config = { position = "left", width = 35 },
            },
        },
    },
}
