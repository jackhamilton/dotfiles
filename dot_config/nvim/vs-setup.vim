" THEMES
if (has("termguicolors"))
    set termguicolors
endif

let g:nvcode_termcolors = 256
let g:sonokai_style = 'default'
syntax on

set autoindent
set smartindent
set ignorecase
set autowrite
"set expandtab

set number
augroup numbertoggle
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
    autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
augroup END

" noremap m h
" noremap n j
" noremap e k
" noremap i l
" noremap j n
" noremap J N
" noremap h m
" noremap l i
" noremap k e

"autocmd CursorHold <buffer> lua vim.lsp.diagnostic.show_line_diagnostics({ focusable = false })

" TSContextEnable

filetype plugin indent on
