set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

" THEMES
if (has("termguicolors"))
    set termguicolors
endif

lua require("lazy-config")
lua require("lazy").setup('user.plugins')
lua require('user')
lua require ('user/lsp')

let g:nvcode_termcolors = 256
let g:sonokai_style = 'default'
syntax on
colorscheme sonokai
" colorscheme nordfox

lua require('user/ui')

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

" trigger `autoread` when files changes on disk
set autoread
autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | checktime | endif
" notification after file change
autocmd FileChangedShellPost *
\ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None
" noremap m h
" noremap n j
" noremap e k
" noremap i l
" noremap j n
" noremap J N
" noremap h m
" noremap l i
" noremap k e

nnoremap <C-m> <C-w>m
nnoremap <C-n> <C-w>n
nnoremap <C-e> <C-w>e
nnoremap <C-i> <C-w>i
nnoremap <C-n> :Neotree<Enter>

"autocmd CursorHold <buffer> lua vim.lsp.diagnostic.show_line_diagnostics({ focusable = false })

TSContextEnable

filetype plugin indent on
