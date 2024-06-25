local function config(_, opts)
    local colorscheme = vim.g.colors_name
    local feline = require('feline')
    local vi_mode = require('feline.providers.vi_mode')
    local file = require('feline.providers.file')
    local separators = require('feline.defaults').statusline.separators.default_value
    local lsp = require('feline.providers.lsp')

    local sonokai = {
        fg = "#E3E1E4",
        bg = "#2D2A2E",
        black = "#1A181A",
        blue = "#354157",
        skyblue = "#7ACCD7",
        cyan = "#78DCE8",
        green = "#9ECD6F",
        oceanblue = "#354157",
        magenta = "#55393D",
        orange = "#EF9062",
        red = "#F85E84",
        violet = "#AB9DF2",
        yellow = "#E5C463",
    }
    require('feline').add_theme('sonokai', sonokai)

    local c = {
        vi_mode_info = {
            -- Component info here
            provider = {
                name = 'vi_mode',
                opts = {
                    show_mode_name = true,
                }
            },
            padding = 'center',
            hl = function()
                return {
                    name = require('feline.providers.vi_mode').get_mode_highlight_name(),
                    bg = require('feline.providers.vi_mode').get_mode_color(),
                    fg = 'bg',
                    style = 'bold'
                }
            end,
            left_sep = {
                always_visible = true,
                str = ' ',
                hl = function()
                    return {
                        bg = require('feline.providers.vi_mode').get_mode_color(),
                        fg = 'bg',
                    }
                end,
            },
            right_sep = {
                always_visible = true,
                str = ' ',
                hl = function()
                    return {
                        bg = require('feline.providers.vi_mode').get_mode_color(),
                        fg = 'bg',
                    }
                end,
            }
        },

        vim_status = {
            provider = function()
                local s
                if require('lazy.status').has_updates() then
                    s = require('lazy.status').updates()
                else
                    s = ''
                end
                s = string.format(' %s ', s)
                return s
            end,
            hl = { fg = 'green', bg = 'bg' },
            right_sep = {
                always_visible = true,
                str = ' ',
                hl = { fg = 'green', bg = 'bg' },
            },
        },

        file_info = {
            -- Component info here
            -- Component that shows file info
            provider = 'file_info',
            hl = {
                bg = 'cyan',
                fg = 'bg',
            },
            left_sep = {
                always_visible = true,
                hl = {
                    bg = 'cyan',
                    fg = 'bg',
                },
                str = ' ',
            },
            right_sep = {
                always_visible = true,
                hl = {
                    bg = 'cyan',
                    fg = 'bg',
                },
                str = ' ',
            },
            -- Uncomment the next line to disable file icons
            -- icon = ''
        },

        file_size = {
            provider = 'file_size',
            hl = {
                bg = "bg",
                fg = "fg",
            },
            left_sep = ' ',
            priority = -9
        },

        git_diff_added = {
            provider = 'git_diff_added',
            hl = {
                fg = "green",
                bg = "bg",
            },
            left_sep = ' ',
        },

        git_diff_removed = {
            provider = 'git_diff_removed',
            hl = {
                fg = "red",
                bg = "bg",
            },
            left_sep = ' ',
        },

        git_diff_changed = {
            provider = 'git_diff_changed',
            hl = {
                fg = "yellow",
                bg = "bg",
            },
            left_sep = ' ',
        },

        diagnostic_hints = {
            provider = 'diagnostic_hints',
            left_sep = ' ',
        },

        diagnostic_errors = {
            provider = 'diagnostic_errors',
            hl = {
                fg = "red",
                bg = "bg",
            },
            left_sep = ' ',
        },

        diagnostic_warnings = {
            provider = 'diagnostic_warnings',
            hl = {
                fg = "yellow",
                bg = "bg",
            },
            left_sep = ' ',
        },

        diagnostic_info = {
            provider = 'diagnostic_info',
            left_sep = ' ',
        },

        git_branch = {
            -- Component info here
            provider = 'git_branch',
            hl = {
                fg = "green",
                bg = "bg",
                style = 'bold'
            },
            left_sep = {
                str = '  ',
                hl = {
                    fg = 'NONE',
                    bg = 'bg'
                }
            },
            right_sep = {
                str = ' ',
                hl = {
                    fg = 'NONE',
                    bg = 'bg'
                }
            },
            priority = -10
        },

        lsp = {
            provider = function()
                if not lsp.is_lsp_attached() then return ' 󱏎 LSP ' end
                return string.format(' %s ', require('lsp-progress').progress())
            end,
            hl = function()
                if not lsp.is_lsp_attached() then return { fg = 'bg', bg = 'fg' } end
                return { fg = 'bg', bg = 'green' }
            end,
            left_sep = {
                always_visible = true,
                str = ' ',
                hl = function()
                    if not lsp.is_lsp_attached() then return { fg = 'bg', bg = 'fg' } end
                    return { fg = 'bg', bg = 'green' }
                end,
            },
            right_sep = {
                always_visible = true,
                str = ' ',
                hl = function()
                    if not lsp.is_lsp_attached() then return { fg = 'fg', bg = 'bg' } end
                    return { fg = 'green', bg = 'none' }
                end,
            },
        },

        macro = {
            provider = function()
                local s
                local recording_register = vim.fn.reg_recording()
                if #recording_register == 0 then
                    s = ''
                else
                    s = string.format(' Recording @%s ', recording_register)
                end
                return s
            end,
            hl = { fg = 'fg', bg = 'bg' },
            left_sep = {
                always_visible = true,
                str = ' ',
                hl = function() return { fg = 'fg', bg = 'bg' } end,
            },
        },

        search_count = {
            provider = function()
                if vim.v.hlsearch == 0 then return '' end

                local ok, result = pcall(vim.fn.searchcount, { maxcount = 999, timeout = 250 })
                if not ok then return '' end
                if next(result) == nil then return '' end

                local denominator = math.min(result.total, result.maxcount)
                return string.format(' [%d/%d] ', result.current, denominator)
            end,
            hl = { fg = 'fg', bg = 'bg' },
            left_sep = {
                always_visible = true,
                str = ' ',
                hl = function() return { fg = 'fg', bg = 'bg' } end,
            },
            right_sep = {
                always_visible = true,
                str = ' ',
                hl = { fg = 'fg', bg = 'bg' },
            },
        },

        scroll_bar = {
            provider = 'scroll_bar',
            hl = {
                fg = "cyan",
                bg = "bg"
            },
            left_sep = ' '
        },
    }

    local active = {
        {
            c.vim_status,
            c.vi_mode_info,
            c.file_info,
            c.lsp,
            c.file_size,
            c.diagnostic_errors,
            c.diagnostic_warnings,
        },
        {
            c.search_count,
            c.macro,
        },
        {
            c.git_diff_added,
            c.git_diff_removed,
            c.git_diff_changed,
            c.git_branch,
            c.scroll_bar,
        },
    }

    local inactive = {
        {
            c.file_info,
            c.file_size,
            c.diagnostic_info,
        },
        {
            c.git_diff_added,
            c.git_diff_removed,
            c.git_diff_changed,
            c.scroll_bar,
        },
    }

    opts.components = { active = active, inactive = inactive }

    feline.setup(opts)
    feline.use_theme("sonokai")
end

return {
    'freddiehaddad/feline.nvim',
    config = config,
    dependencies = {
        -- 'sainnhe/sonokai',
        'lewis6991/gitsigns.nvim',
        'nvim-tree/nvim-web-devicons',
        {
            'linrongbin16/lsp-progress.nvim',
            opts = {
                spinner = { '⠋', '⠙', '⠸', '⢰', '⣠', '⣄', '⡆', '⠇' },
                client_format = function(_, spinner, series_messages)
                    return #series_messages > 0 and (spinner .. ' LSP') or
                        ' LSP'
                end,
                format = function(client_messages)
                    local sign = ' LSP'
                    if #client_messages > 0 then return table.concat(client_messages) end
                    if #vim.lsp.get_clients() > 0 then return sign end
                    return '󱏎 LSP'
                end,
            },
        },
    },
    init = function()
        -- update statusbar when there's a plugin update
        vim.api.nvim_create_autocmd('User', {
            pattern = 'LazyCheck',
            callback = function() vim.opt.statusline = vim.opt.statusline end,
        })

        -- update statusbar with LSP progress
        vim.api.nvim_create_augroup('feline_augroup', { clear = true })
        vim.api.nvim_create_autocmd('User', {
            group = 'feline_augroup',
            pattern = 'LspProgressStatusUpdated',
            callback = function() vim.opt.statusline = vim.opt.statusline end,
        })

        -- hide search count on command line
        vim.opt.shortmess:append({ S = true })
    end,
    opts = {
        force_inactive = { filetypes = { '^dapui_*', '^help$', '^neotest*', '^NvimTree$', '^qf$' } },
        disable = { filetypes = { '^alpha$' } },
    },
}
