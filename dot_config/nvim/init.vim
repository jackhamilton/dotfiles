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

nnoremap <C-A-Left> <C-w>h
nnoremap <C-A-Up> <C-w>k
nnoremap <C-A-Down> <C-w>j
nnoremap <C-A-Right> <C-w>l
nnoremap <C-A-u> <C-w>v
nnoremap <C-A-y> <C-w>s
nnoremap <C-n> :lua MiniFiles.open()<CR>
nnoremap <C-S-r> :Telescope smart_open<CR>
nnoremap <C-S-b> :Telescope buffers<CR>
nnoremap <C-S-o> :Telescope find_files<CR>

"autocmd CursorHold <buffer> lua vim.lsp.diagnostic.show_line_diagnostics({ focusable = false })

TSContextEnable

filetype plugin indent on
